#!/bin/bash
source /home/node/.openclaw/.env 2>/dev/null

task_ids=(
  "87611251-6ecc-40fc-9d2b-c577b0959e97"
  "b54fda19-6fe8-4aee-9616-1142fb487016"
  "3673b42b-66a2-4271-835a-2f02dc547b13"
  "6360051f-0144-499a-be9b-1ccd4212115b"
  "f7b3d30d-9815-4f86-b5a2-f238d22afced"
)

echo "开始轮询 5 个图片生成任务..."
echo ""

for i in {1..30}; do
  echo "===== 检查 $i/30 ====="
  all_done=true
  
  for idx in {0..4}; do
    task_id="${task_ids[$idx]}"
    result=$(curl -s -X POST "https://api.xskill.ai/api/v3/tasks/query" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $XSKILL_API_KEY" \
      -d "{\"task_id\": \"$task_id\"}")
    
    status=$(echo "$result" | jq -r ".data.status")
    image=$(echo "$result" | jq -r ".data.output.images[0] // empty")
    
    echo "场景$((idx+1)): $status"
    
    if [ "$status" = "completed" ] || [ "$status" = "success" ]; then
      if [ -n "$image" ] && [ "$image" != "null" ]; then
        echo "  ✅ 图片URL: $image"
      fi
    elif [ "$status" = "processing" ] || [ "$status" = "pending" ]; then
      all_done=false
    fi
  done
  
  echo ""
  
  if [ "$all_done" = true ]; then
    echo "===== 所有任务完成 ====="
    break
  fi
  
  echo "等待 5 秒..."
  sleep 5
done
