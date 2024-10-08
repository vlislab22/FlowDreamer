#!/bin/bash

# # 要搜索的文件夹路径
# DIR="web_videos_2"

# # 遍历文件夹中的所有视频文件
# find "$DIR" -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.avi" -o -iname "*.mov" \) | while read FILE; do
#     # 检查视频编码
#     CODEC=$(ffmpeg -i "$FILE" 2>&1 | grep "Video:" | awk '{print $3}')
    
#     if [ "$CODEC" != "h264" ]; then
#         echo "Converting $FILE (codec: $CODEC) to H.264..."
        
#         # 使用 H.264 编码转换视频，覆盖原文件
#         ffmpeg -i "$FILE" -c:v libx264 -c:a copy -y "$FILE"
        
#         echo "Conversion complete: $FILE"
#     else
#         echo "$FILE is already H.264 encoded."
#     fi
# done

# 创建目标目录，如果不存在
mkdir -p web_videos_3

# 遍历 web_videos_2 目录中的所有视频文件
for file in web_videos_2/*.mp4; do
    # 提取文件名，不带路径
    filename=$(basename "$file")
    
    # 检查文件的编码格式
    codec=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of csv=p=0 "$file")
    
    # 如果视频格式是 H.264，则直接复制到 web_videos_3
    if [ "$codec" == "h264" ]; then
        cp "$file" "web_videos_3/$filename"
    else
        # 如果不是 H.264 格式，则将视频转换为 H.264，并保存到 web_videos_3
        ffmpeg -i "$file" -c:v libx264 -c:a copy "web_videos_3/$filename"
    fi
done

echo "所有文件已处理并保存到 web_videos_3 目录中。"