
import cv2
import numpy as np
import os

# 设置
fps = 30
width = 1080
height = 1920
output_file = 'output.mp4'

# 创建视频写入器
fourcc = cv2.VideoWriter_fourcc(*'mp4v')
video = cv2.VideoWriter(output_file, fourcc, fps, (width, height))

# 读取并写入帧
frames_dir = 'frames'
frame_files = sorted([f for f in os.listdir(frames_dir) if f.endswith('.png')])

print(f'处理 {len(frame_files)} 帧...')

for idx, frame_file in enumerate(frame_files):
    frame_path = os.path.join(frames_dir, frame_file)
    frame = cv2.imread(frame_path)
    
    if frame is not None:
        video.write(frame)
    
    if idx % 100 == 0:
        print(f'进度: {idx}/{len(frame_files)}')

video.release()
print(f'✅ 视频已保存: {output_file}')
