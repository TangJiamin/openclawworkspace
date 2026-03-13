#!/bin/bash
# Translate Script v1.0
# Based on baoyu-translate, simplified for OpenClaw

set -e

# Directory setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_BASE="${BASE_DIR}/output"

# Create output directory
mkdir -p "$OUTPUT_BASE"

# Default values
MODE="${MODE:-normal}"
FROM_LANG="${FROM_LANG:-auto}"
TO_LANG="${TO_LANG:-zh-CN}"
AUDIENCE="${AUDIENCE:-general}"
STYLE="${STYLE:-storytelling}"
CHUNK_THRESHOLD=${CHUNK_THRESHOLD:-4000}
CHUNK_MAX_WORDS=${CHUNK_MAX_WORDS:-5000}

# Parse arguments
SOURCE=""
while [[ $# -gt 0 ]]; do
  case $1 in
    --mode)
      MODE="$2"
      shift 2
      ;;
    --from)
      FROM_LANG="$2"
      shift 2
      ;;
    --to)
      TO_LANG="$2"
      shift 2
      ;;
    --audience)
      AUDIENCE="$2"
      shift 2
      ;;
    --style)
      STYLE="$2"
      shift 2
      ;;
    *)
      SOURCE="$1"
      shift
      ;;
  esac
done

# Validate source
if [[ -z "$SOURCE" ]]; then
  echo "❌ Error: No source provided"
  echo "Usage: $0 [--mode quick|normal|refined] [--from <lang>] [--to <lang>] [--audience <audience>] [--style <style>] <source>"
  exit 1
fi

# Determine source type and materialize
if [[ -f "$SOURCE" ]]; then
  # File input
  SOURCE_FILE="$SOURCE"
  SOURCE_BASENAME="$(basename "$SOURCE" | sed 's/\.[^.]*$//')"
elif [[ "$SOURCE" =~ ^https?:// ]]; then
  # URL input
  SOURCE_FILE="$OUTPUT_BASE/url-$(date +%s).md"
  echo "# Source: $SOURCE" > "$SOURCE_FILE"
  echo "" >> "$SOURCE_FILE"
  curl -s "$SOURCE" >> "$SOURCE_FILE" 2>/dev/null || {
    echo "❌ Error: Failed to fetch URL"
    exit 1
  }
  SOURCE_BASENAME="url-$(date +%s)"
else
  # Inline text input
  SOURCE_FILE="$OUTPUT_BASE/inline-$(date +%s).md"
  echo "$SOURCE" > "$SOURCE_FILE"
  SOURCE_BASENAME="inline-$(date +%s)"
fi

# Create output directory
OUTPUT_DIR="${OUTPUT_BASE}/${SOURCE_BASENAME}-${TO_LANG}"
mkdir -p "$OUTPUT_DIR"

# Copy source to output directory
cp "$SOURCE_FILE" "$OUTPUT_DIR/source.md"

# Detect source language if auto
if [[ "$FROM_LANG" == "auto" ]]; then
  # Simple heuristic: check for Chinese characters
  if grep -qE '[\u4e00-\u9fa5]' "$SOURCE_FILE"; then
    FROM_LANG="zh-CN"
  else
    FROM_LANG="en"
  fi
fi

echo "📝 Translation Task"
echo "================"
echo "Source: $SOURCE_FILE"
echo "Languages: $FROM_LANG → $TO_LANG"
echo "Mode: $MODE"
echo "Audience: $AUDIENCE"
echo "Style: $STYLE"
echo "Output: $OUTPUT_DIR/"
echo ""

# Load glossary
GLOSSARY=""
if [[ -f "$BASE_DIR/glossary.md" ]]; then
  GLOSSARY=$(cat "$BASE_DIR/glossary.md")
fi

# Quick mode
if [[ "$MODE" == "quick" ]]; then
  echo "🚀 Quick mode: Direct translation"
  echo ""
  
  # Direct translation without analysis
  cat "$SOURCE_FILE" | translate_quick > "$OUTPUT_DIR/translation.md"
  
  echo "✅ Translation complete!"
  echo "Output: $OUTPUT_DIR/translation.md"
  exit 0
fi

# Normal or Refined mode
echo "🔍 Analyzing content..."
echo ""

# Step 1: Analyze content
cat > "$OUTPUT_DIR/01-analysis.md" << EOF
# Content Analysis

**Source Language**: $FROM_LANG
**Target Language**: $TO_LANG
**Target Audience**: $AUDIENCE
**Translation Style**: $STYLE

## Domain & Tone
$(detect_domain "$SOURCE_FILE")

## Key Terminology
$(extract_terminology "$SOURCE_FILE")

## Comprehension Challenges
$(identify_challenges "$SOURCE_FILE")

## Figurative Language & Metaphor Mapping
$(map_metaphors "$SOURCE_FILE")
EOF

echo "✅ Analysis complete: $OUTPUT_DIR/01-analysis.md"

# Step 2: Assemble translation prompt
echo "📋 Assembling translation prompt..."
cat > "$OUTPUT_DIR/02-prompt.md" << EOF
# Translation Instructions

## Context
$(cat "$OUTPUT_DIR/01-analysis.md")

## Glossary
$GLOSSARY

## Translation Principles
1. **Accuracy first**: Facts, data, and logic must match the original exactly
2. **Meaning over words**: Translate what the author means, not just what the words say
3. **Natural flow**: Use idiomatic target language word order and sentence patterns
4. **Terminology**: Use standard translations; annotate with original term in parentheses on first occurrence
5. **Emotional fidelity**: Preserve the emotional connotations of word choices

## Target Audience
$AUDIENCE

## Translation Style
$STYLE

## Task
Translate the following content from $FROM_LANG to $TO_LANG following the principles above.
EOF

echo "✅ Prompt assembled: $OUTPUT_DIR/02-prompt.md"

# Step 3: Estimate word count and decide on chunking
WORD_COUNT=$(wc -w < "$SOURCE_FILE" | awk '{print $1}')
echo "📊 Content length: $WORD_COUNT words"

if [[ $WORD_COUNT -ge $CHUNK_THRESHOLD ]]; then
  echo "⚠️  Content exceeds threshold ($CHUNK_THRESHOLD words)"
  echo "📦 Chunking enabled..."
  
  # Extract terminology for consistency
  echo "🔤 Extracting terminology..."
  
  # Split into chunks (simplified - by headings)
  chunk_count=1
  current_chunk=""
  chunk_dir="$OUTPUT_DIR/chunks"
  mkdir -p "$chunk_dir"
  
  # Read file line by line and split by headings
  while IFS= read -r line; do
    if [[ "$line" =~ ^#+\  ]]; then
      # Heading found - save current chunk if not empty
      if [[ -n "$current_chunk" ]]; then
        printf "%s\n" "$current_chunk" > "$chunk_dir/chunk-$(printf "%02d" $chunk_count).md"
        ((chunk_count++))
        current_chunk="$line"$'\n'
      else
        current_chunk="$line"$'\n'
      fi
    else
      current_chunk+="$line"$'\n'
    fi
  done < "$SOURCE_FILE"
  
  # Save last chunk
  if [[ -n "$current_chunk" ]]; then
    printf "%s\n" "$current_chunk" > "$chunk_dir/chunk-$(printf "%02d" $chunk_count).md"
    ((chunk_count++))
  fi
  
  echo "✅ Split into $chunk_count chunks"
  
  # Translate chunks (in parallel if possible)
  echo "🔄 Translating chunks..."
  for i in $(seq 1 $chunk_count); do
    chunk_num=$(printf "%02d" $i)
    chunk_file="$chunk_dir/chunk-${chunk_num}.md"
    draft_file="$chunk_dir/chunk-${chunk_num}-draft.md"
    
    if [[ -f "$chunk_file" ]]; then
      echo "  📝 Translating chunk $i/$chunk_count..."
      
      # Translate chunk
      translate_chunk "$chunk_file" "$draft_file" "$OUTPUT_DIR/02-prompt.md"
    fi
  done
  
  # Merge chunks
  echo "🔗 Merging translated chunks..."
  > "$OUTPUT_DIR/03-draft.md"
  
  if [[ -f "$chunk_dir/frontmatter.md" ]]; then
    cat "$chunk_dir/frontmatter.md" >> "$OUTPUT_DIR/03-draft.md"
    echo "" >> "$OUTPUT_DIR/03-draft.md"
  fi
  
  for i in $(seq 1 $chunk_count); do
    chunk_num=$(printf "%02d" $i)
    draft_file="$chunk_dir/chunk-${chunk_num}-draft.md"
    
    if [[ -f "$draft_file" ]]; then
      cat "$draft_file" >> "$OUTPUT_DIR/03-draft.md"
      echo "" >> "$OUTPUT_DIR/03-draft.md"
    fi
  done
  
  echo "✅ Draft merged: $OUTPUT_DIR/03-draft.md"
  
  # For normal mode, copy draft as final translation
  if [[ "$MODE" == "normal" ]]; then
    cp "$OUTPUT_DIR/03-draft.md" "$OUTPUT_DIR/translation.md"
    echo "✅ Translation complete!"
    echo "Output: $OUTPUT_DIR/translation.md"
    echo ""
    echo "💡 To further refine, reply: 继续润色"
    exit 0
  fi
  
  # For refined mode, continue with review
  DRAFT_FILE="$OUTPUT_DIR/03-draft.md"
else
  # No chunking needed
  echo "✅ Content length suitable for single-pass translation"
  
  # Translate directly
  echo "🔄 Translating..."
  translate_document "$SOURCE_FILE" "$OUTPUT_DIR/03-draft.md" "$OUTPUT_DIR/02-prompt.md"
  
  echo "✅ Draft complete: $OUTPUT_DIR/03-draft.md"
  
  # For normal mode, copy draft as final translation
  if [[ "$MODE" == "normal" ]]; then
    cp "$OUTPUT_DIR/03-draft.md" "$OUTPUT_DIR/translation.md"
    echo "✅ Translation complete!"
    echo "Output: $OUTPUT_DIR/translation.md"
    echo ""
    echo "💡 To further refine, reply: 继续润色"
    exit 0
  fi
  
  DRAFT_FILE="$OUTPUT_DIR/03-draft.md"
fi

# Refined mode: Step 4-6
if [[ "$MODE" == "refined" ]]; then
  echo ""
  echo "🔍 Refined mode: Full quality workflow"
  echo ""
  
  # Step 4: Critical review
  echo "📝 Step 4/6: Critical review..."
  review_translation "$DRAFT_FILE" "$OUTPUT_DIR/02-prompt.md" > "$OUTPUT_DIR/04-critique.md"
  echo "✅ Review complete: $OUTPUT_DIR/04-critique.md"
  
  # Step 5: Revision
  echo "📝 Step 5/6: Revision..."
  revise_translation "$DRAFT_FILE" "$OUTPUT_DIR/04-critique.md" > "$OUTPUT_DIR/05-revision.md"
  echo "✅ Revision complete: $OUTPUT_DIR/05-revision.md"
  
  # Step 6: Polish
  echo "📝 Step 6/6: Final polish..."
  polish_translation "$OUTPUT_DIR/05-revision.md" > "$OUTPUT_DIR/translation.md"
  echo "✅ Polish complete: $OUTPUT_DIR/translation.md"
  
  echo ""
  echo "✅ Refined translation complete!"
  echo "Output: $OUTPUT_DIR/translation.md"
fi

echo ""
echo "📊 Summary"
echo "========"
echo "Mode: $MODE"
echo "Source: $SOURCE_FILE"
echo "Languages: $FROM_LANG → $TO_LANG"
echo "Output dir: $OUTPUT_DIR/"
echo "Final: $OUTPUT_DIR/translation.md"
echo "Glossary terms applied: $(echo "$GLOSSARY" | grep -c '^|' || echo 0)"
