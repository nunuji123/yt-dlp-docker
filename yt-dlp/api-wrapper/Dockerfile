FROM jauderho/yt-dlp:latest AS yt-dlp

FROM node:18-alpine

WORKDIR /app

# 复制yt-dlp二进制文件
COPY --from=yt-dlp /usr/local/bin/yt-dlp /usr/local/bin/yt-dlp

# 安装依赖
RUN apk add --no-cache ffmpeg ca-certificates python3 tzdata

# 安装Node.js依赖
COPY package*.json ./
RUN npm install

# 复制应用代码
COPY . .

EXPOSE 3000

CMD ["node", "server.js"] 