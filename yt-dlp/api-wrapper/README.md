# yt-dlp API Wrapper

这是一个简单的API服务，封装了yt-dlp的功能，使您可以通过HTTP请求下载YouTube视频。

## 功能特点

- 获取视频信息
- 下载特定格式和质量的视频
- 仅下载音频
- 下载字幕
- 获取支持的视频格式列表

## 部署方法

### 使用Docker

```bash
# 构建Docker镜像
docker build -t yt-dlp-api .

# 运行Docker容器
docker run -p 3000:3000 -v $(pwd)/downloads:/downloads yt-dlp-api
```

### 使用Docker Compose

```bash
# 在docker-compose.yml所在目录运行
docker-compose up -d
```

## API接口

### 健康检查

```
GET /health
```

返回API服务的运行状态。

### 获取视频信息

```
GET /api/info?url={video_url}
```

返回视频的详细元数据信息，不进行下载。

### 获取视频支持的格式

```
GET /api/formats?url={video_url}
```

返回视频支持的所有格式列表。

### 下载视频

```
POST /api/download
Content-Type: application/json

{
  "url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  "format": "22",
  "audioOnly": false,
  "subtitles": false
}
```

参数说明:
- `url`: 必填，YouTube视频URL
- `format`: 可选，视频格式代码（如"22"表示720p MP4）
- `audioOnly`: 可选，设为true则仅提取音频
- `quality`: 可选，音频质量（当audioOnly为true时使用）
- `subtitles`: 可选，设为true则下载字幕

## 示例请求

### 使用curl下载视频

```bash
curl -X POST http://localhost:3000/api/download \
  -H "Content-Type: application/json" \
  -d '{"url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ"}'
```

### 使用JavaScript获取视频信息

```javascript
fetch('http://localhost:3000/api/info?url=https://www.youtube.com/watch?v=dQw4w9WgXcQ')
  .then(response => response.json())
  .then(data => console.log(data))
  .catch(error => console.error('Error:', error));
```

## 注意事项

- 所有下载的文件将保存在`/downloads`目录中
- API服务默认在端口3000上运行，可以通过环境变量`PORT`进行修改
- 下载目录可以通过环境变量`DOWNLOADS_DIR`进行修改 