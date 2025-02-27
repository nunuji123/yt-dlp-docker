FROM jauderho/yt-dlp:latest 

# 设置工作目录
WORKDIR /app

# 复制项目文件
COPY ./yt-dlp /app

# 设置时区
ENV TZ=Asia/Shanghai

# 创建下载目录
RUN mkdir -p /downloads && \
    chmod 777 /downloads

# 卷挂载点
VOLUME ["/downloads", "/config"]

# 保持容器运行
CMD ["tail", "-f", "/dev/null"] 