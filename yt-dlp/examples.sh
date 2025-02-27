#!/bin/bash
# yt-dlp Docker 使用示例脚本

# 设置颜色变量
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${CYAN}===== yt-dlp Docker 使用示例 =====${NC}\n"

# 确保目录存在
mkdir -p downloads

# 基本下载示例
run_example() {
  echo -e "${GREEN}示例 $1:${NC} $2"
  echo -e "${YELLOW}命令:${NC} $3"
  echo -e "按 Enter 键运行示例，或按 Ctrl+C 退出..."
  read
  eval $3
  echo -e "\n"
}

# 示例1: 基本视频下载
run_example "1" "基本视频下载" "docker run --rm -v \"\$(pwd)/downloads:/downloads\" jauderho/yt-dlp:latest https://www.youtube.com/watch?v=dQw4w9WgXcQ"

# 示例2: 下载指定格式和质量
run_example "2" "下载指定格式和质量 (1080p MP4)" "docker run --rm -v \"\$(pwd)/downloads:/downloads\" jauderho/yt-dlp:latest -f 'bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]' https://www.youtube.com/watch?v=dQw4w9WgXcQ"

# 示例3: 仅下载音频
run_example "3" "仅下载音频 (MP3)" "docker run --rm -v \"\$(pwd)/downloads:/downloads\" jauderho/yt-dlp:latest -x --audio-format mp3 --audio-quality 0 https://www.youtube.com/watch?v=dQw4w9WgXcQ"

# 示例4: 使用配置文件
run_example "4" "使用配置文件下载" "docker run --rm -v \"\$(pwd)/downloads:/downloads\" -v \"\$(pwd)/config:/config\" jauderho/yt-dlp:latest --config-location /config/yt-dlp.conf https://www.youtube.com/watch?v=dQw4w9WgXcQ"

# 示例5: 下载播放列表
run_example "5" "下载播放列表中的前3个视频" "docker run --rm -v \"\$(pwd)/downloads:/downloads\" jauderho/yt-dlp:latest --playlist-items 1-3 https://www.youtube.com/playlist?list=PLbpi6ZahtOH6Blw3RGYpWkSByi_T7Rygb"

# 示例6: 使用代理
run_example "6" "使用代理下载" "docker run --rm -v \"\$(pwd)/downloads:/downloads\" -e HTTP_PROXY=\"http://host.docker.internal:7890\" -e HTTPS_PROXY=\"http://host.docker.internal:7890\" jauderho/yt-dlp:latest https://www.youtube.com/watch?v=dQw4w9WgXcQ"

# 示例7: 获取视频信息但不下载
run_example "7" "只获取视频信息，不下载" "docker run --rm jauderho/yt-dlp:latest --skip-download --print info_json https://www.youtube.com/watch?v=dQw4w9WgXcQ"

# 示例8: 下载字幕
run_example "8" "下载字幕" "docker run --rm -v \"\$(pwd)/downloads:/downloads\" jauderho/yt-dlp:latest --skip-download --write-subs --sub-langs all https://www.youtube.com/watch?v=dQw4w9WgXcQ"

# 示例9: 批量下载文件中的URL
echo -e "${GREEN}示例 9:${NC} 批量下载文件中的URL"
echo -e "${YELLOW}准备批量下载文件...${NC}"
cat > downloads/url-list.txt << EOF
https://www.youtube.com/watch?v=dQw4w9WgXcQ
https://www.youtube.com/watch?v=LXb3EKWsInQ
EOF
echo "已创建downloads/url-list.txt文件"
run_example "9" "批量下载文件中的URL" "docker run --rm -v \"\$(pwd)/downloads:/downloads\" jauderho/yt-dlp:latest -a /downloads/url-list.txt"

# 示例10: 使用Docker Compose运行
echo -e "${GREEN}示例 10:${NC} 使用Docker Compose运行"
echo -e "${YELLOW}命令:${NC} docker-compose run --rm yt-dlp https://www.youtube.com/watch?v=dQw4w9WgXcQ"
echo -e "按 Enter 键运行示例，或按 Ctrl+C 退出..."
read
docker-compose run --rm yt-dlp https://www.youtube.com/watch?v=dQw4w9WgXcQ
echo -e "\n"

echo -e "${CYAN}===== 所有示例执行完毕 =====${NC}"
echo -e "下载的文件保存在 ./downloads 目录下" 