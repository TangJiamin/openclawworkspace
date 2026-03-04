#!/bin/bash
# Test script for seedance-storyboard skill

echo "=== Seedance Storyboard Skill Test ==="
echo ""

# Test 1: Basic workflow understanding
echo "Test 1: 基础工作流程"
echo ""
echo "用户: 我想做一个女孩在海边跳舞的视频"
echo ""
echo "我应该引导："
echo "  1. 舞蹈风格？（现代舞/古典舞/街舞/自由舞动）"
echo "  2. 什么时间？（日出/白天/日落/夜晚）"
echo "  3. 整体氛围？（欢快/忧伤/自由/浪漫）"
echo "  4. 时长多少秒？"
echo "  5. 有参考素材吗？"
echo ""

# Test 2: Storyboard structure
echo "Test 2: 分镜结构构建"
echo ""
echo "15秒视频标准结构："
echo "  0-3秒：开场镜头，建立场景"
echo "  3-7秒：发展，引入主体"
echo "  7-11秒：高潮，核心动作"
echo "  11-13秒：转折/过渡"
echo "  13-15秒：结尾/落版"
echo ""

# Test 3: Prompt template
echo "Test 3: 提示词模板验证"
echo ""

cat << 'EOF'
【整体描述】电影级写实风格，15秒，16:9宽屏，日落黄金时刻的温暖氛围

【分镜描述】
0-3秒：远景缓慢推近，海平线夕阳，女孩剪影站在沙滩上，裙摆被海风吹动
3-7秒：中景环绕镜头，女孩开始旋转起舞，长发和裙摆飞扬，夕阳逆光形成轮廓光
7-11秒：近景跟随移动，女孩面向镜头舞动，表情自由愉悦，海浪轻拍沙滩作为背景
11-13秒：特写手部动作，手指划过夕阳，光影在指尖流转
13-15秒：远景拉远，女孩在落日余晖中定格，画面渐暗

【声音说明】海浪声 + 轻柔的钢琴配乐
EOF

echo ""

# Test 4: Multimodal syntax
echo "Test 4: 多模态输入语法"
echo ""
echo "参考素材标注："
echo "  @图片1 作为首帧/角色参考"
echo "  @视频1 参考运镜/动作"
echo "  @音频1 用于配乐/对白参考"
echo ""

# Test 5: Special scenarios
echo "Test 5: 特殊场景"
echo ""
echo "场景1: 视频延长"
echo "  提示词: 将@视频1延长5s"
echo ""
echo "场景2: 角色替换"
echo "  提示词: 将@视频1中的女生换成@图片1的戏曲花旦形象"
echo ""
echo "场景3: 运镜复刻"
echo "  提示词: 完全参考@视频1的所有运镜效果和主角面部表情"
echo ""

# Test 6: Limitations
echo "Test 6: 平台限制"
echo ""
echo "限制条件："
echo "  ❌ 暂不支持写实真人脸部素材"
echo "  ⚠️ 视频参考消耗更多额度"
echo "  ⚠️ 混合输入总上限12个文件"
echo "  ⚠️ 视频像素范围: 480p-720p"
echo ""

echo "=== 测试完成 ==="
