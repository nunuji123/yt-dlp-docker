# YouTube 下载工具集合

这个项目提供了两种使用 yt-dlp 下载 YouTube 视频的方法：

1. **基本 Docker 部署**：使用 `jauderho/yt-dlp` 镜像，通过命令行下载视频
2. **API 包装器**：提供 RESTful API 和 Web 界面，更方便地下载视频

## 基本 Docker 部署

### 目录结构

```
yt-dlp/
├── config/             # 配置文件目录
│   └── yt-dlp.conf     # yt-dlp 配置文件
├── downloads/          # 下载的视频将保存在这里
└── docker-compose.yml  # Docker Compose 配置文件
```

### 使用方法

1. 确保已安装 Docker 和 Docker Compose
2. 在 `yt-dlp` 目录中运行以下命令启动容器：

```bash
docker-compose up -d
```

3. 使用以下命令下载视频：

```bash
docker-compose exec yt-dlp yt-dlp https://www.youtube.com/watch?v=dQw4w9WgXcQ
```

更多用法示例，请查看 `examples.sh` 文件。

## API 包装器服务

API 服务提供了一个简单的 RESTful API 和 Web 界面，使您能够更方便地下载 YouTube 视频。

### 目录结构

```
yt-dlp/
└── api-wrapper/
    ├── public/         # 静态文件和 Web 界面
    │   └── index.html  # Web 界面
    ├── Dockerfile      # 构建 API 服务的 Docker 配置
    ├── package.json    # Node.js 项目依赖
    ├── server.js       # API 服务器代码
    └── docker-compose.yml  # Docker Compose 配置文件
```

### 使用方法

1. 确保已安装 Docker 和 Docker Compose
2. 在 `yt-dlp/api-wrapper` 目录中运行以下命令启动 API 服务：

```bash
docker-compose up -d
```

3. 访问 `http://localhost:3000` 使用 Web 界面下载视频

### API 端点

API 服务提供以下端点：

- `GET /health` - 健康检查
- `GET /api/info?url=<video_url>` - 获取视频信息
- `GET /api/formats?url=<video_url>` - 获取视频支持的格式
- `POST /api/download` - 下载视频，接受 JSON 格式的参数

有关 API 详细使用方法，请参阅 `api-wrapper/README.md` 文件。

## 注意事项

- 所有下载的视频将保存在 `downloads` 目录中
- 确保您有足够的磁盘空间用于存储下载的视频
- 使用 yt-dlp 下载视频时请遵守当地法律法规和 YouTube 的服务条款
- 此工具仅用于个人学习和研究目的

## yt-dlp video_info.json 字段说明

当使用 yt-dlp 下载视频时，生成的 video_info.json 文件包含视频的详细信息。以下是主要字段的含义：

### 基本信息字段

- `id`: YouTube 视频的唯一标识符 (例如：aZdY0ywuJ4M)
- `title`: 视频标题
- `_filename`/`filename`: 下载的视频文件名
- `_type`: 内容类型 (通常为 "video")
- `_version`: yt-dlp 版本信息

### 视频质量相关字段

- `width` & `height`: 视频分辨率 (例如：1920x1080)
- `resolution`: 视频分辨率的文字表示 (例如："1920x1080")
- `fps`: 视频帧率 (例如：30 fps)
- `dynamic_range`: 动态范围类型 (例如：SDR)
- `aspect_ratio`: 视频宽高比 (例如：1.78，即 16:9)
- `stretched_ratio`: 拉伸比例，如果有的话

### 编解码相关字段

- `vcodec`: 视频编码格式 (例如：vp9)
- `acodec`: 音频编码格式 (例如：opus)
- `vbr`: 视频比特率 (例如：333.342 kbps)
- `abr`: 音频比特率 (例如：108.625 kbps)
- `tbr`: 总比特率 (例如：441.967 kbps)
- `asr`: 音频采样率 (例如：48000 Hz)
- `audio_channels`: 音频通道数 (例如：2 表示立体声)
- `ext`: 文件扩展名 (例如：webm)

### 视频实际资源地址

**视频的实际资源地址在 `formats` 数组中**。每个格式对象包含以下关键字段：

- `format_id`: 格式的唯一标识符
- `format_note`: 格式的简短描述 (例如：1080p, 720p, medium 等)
- `url`: **这是视频/音频资源的实际 URL 地址**。这是视频实际资源的请求地址。

在 `formats` 数组中，包含了多种不同质量和格式的视频和音频流：

1. 纯视频流：`vcodec` 不是 "none"，而 `acodec` 是 "none"
2. 纯音频流：`acodec` 不是 "none"，而 `vcodec` 是 "none"
3. 混合流：同时包含视频和音频

### 最终选择的格式

在文件末尾，有一个摘要部分显示了 yt-dlp 最终选择的格式组合，例如：

```
"format": "248 - 1920x1080 (1080p)+251 - audio only (medium)",
"format_id": "248+251",
```

这表明 yt-dlp 选择了：

- `248` 格式的视频流（高分辨率视频）
- `251` 格式的音频流（中等质量音频）
- 并将它们合并成了一个文件

需要注意的是，这些 URL 通常是临时的、带有签名和过期时间的，不能直接长期保存使用。yt-dlp 在下载过程中会获取这些流并合并它们。
