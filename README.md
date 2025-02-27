# chrome-youtube-downloader

## 在Docker容器内执行yt-dlp下载命令

由于yt-dlp工具安装在Docker容器内部，而不是在主机系统上，因此需要先进入容器才能执行下载命令。请按照以下步骤操作：

### 1. 找到正在运行的容器

```bash
docker ps
```

这将列出所有正在运行的容器。找到包含yt-dlp工具的容器ID或名称。

### 2. 进入容器内部

```bash
docker exec -it 容器ID或名称 /bin/bash
# 或者
docker exec -it 容器ID或名称 /bin/sh
```

### 3. 在容器内部执行yt-dlp命令

```bash
yt-dlp --proxy https://nunuji123-deno-server-56.deno.dev/ -o "/downloads/%(title)s-%(id)s.%(ext)s" "https://www.youtube.com/watch?v=VIDEO_ID"
```

请将 `VIDEO_ID` 替换为实际的YouTube视频ID。

### 注意事项

- **下载目录**: 确保容器内的 `/downloads` 目录存在并有写入权限。如果不确定，可以先创建：
  ```bash
  mkdir -p /downloads
  ```

- **网络连接**: 如果遇到网络问题，可以在容器内检查网络连接：
  ```bash
  ping -c 3 google.com
  # 或
  curl -I https://www.youtube.com
  ```

- **代理设置**: 命令中使用了README提供的代理服务。如果下载仍然失败，可以检查代理是否可访问：
  ```bash
  curl -I https://nunuji123-deno-server-56.deno.dev/
  ```

- **常见错误**:
  - `Network unreachable`: 容器内网络配置问题，检查网络设置或代理
  - `Permission denied`: 没有写入权限，检查目录权限
  - `No space left on device`: 容器或主机存储空间不足

### 快速故障排除

如果遇到 `Network unreachable` 错误，可能是因为容器无法直接访问互联网。请务必使用提供的代理：

```bash
yt-dlp --proxy https://nunuji123-deno-server-56.deno.dev/ [其他选项] "YouTube URL"
```

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

## GitHub Codespaces 部署说明

本项目支持使用 GitHub Codespaces 进行开发和部署。每次向 master 分支提交代码时，会自动触发部署流程。

### Git提交人配置

本项目已配置了固定的Git提交人信息，用于标识提交来源。在GitHub Actions自动部署流程中，使用以下配置：

```bash
# 提交人姓名
git config --global user.name nunuji123@163.com

# 提交人邮箱
git config --global user.email "nunuji123@163.com"
```

如果您是项目贡献者，可以在本地设置不同的提交人信息：

```bash
# 仅为当前项目设置提交人信息
git config user.name "您的姓名"
git config user.email "您的邮箱"

# 或者设置全局提交人信息
git config --global user.name "您的姓名"
git config --global user.email "您的邮箱"
```

### 使用 GitHub Codespaces 进行开发

1. 在 GitHub 仓库页面点击 "Code" 按钮，然后选择 "Open with Codespaces"
2. 点击 "New codespace" 创建一个新的开发环境
3. 系统会自动配置开发环境，包括安装必要的依赖和工具
4. 环境准备就绪后，你可以直接在浏览器中进行开发

### 自动部署流程

本项目配置了 GitHub Actions 工作流，在提交到 master 分支时自动执行以下操作：

1. 检出代码库
2. 设置 Docker Buildx 环境
3. 登录到 GitHub Container Registry (GHCR)
4. 构建 Docker 镜像并推送到 GHCR
   - 标签包括 `latest` 和当前 commit 的 SHA 值
5. 镜像构建完成后即可使用

### 使用已部署的镜像

```bash
# 拉取最新镜像
docker pull ghcr.io/USERNAME/yt-dlp-docker:latest

# 运行容器
docker run -d \
  --name yt-dlp \
  -v ./downloads:/downloads \
  -v ./config:/config \
  ghcr.io/USERNAME/yt-dlp-docker:latest
```

请将 `USERNAME` 替换为您的 GitHub 用户名。

### 部署方式的优缺点

#### 优点

1. **自动化部署**：代码推送到 master 分支后自动触发部署，无需手动干预
2. **版本追踪**：每个版本都有唯一的标签（commit SHA），方便回滚或追踪问题
3. **开发环境一致性**：Codespaces 确保所有开发者使用相同的环境配置
4. **资源节约**：不需要本地安装开发环境，使用云端资源
5. **即开即用**：新成员可以快速加入项目，无需复杂的环境配置

#### 缺点

1. **依赖 GitHub 服务**：如果 GitHub 服务不可用，将无法进行开发和部署
2. **网络要求**：需要稳定的网络连接
3. **资源限制**：GitHub Codespaces 有使用时间和资源的限制
4. **可能产生费用**：超出免费额度后可能需要支付费用
5. **学习成本**：团队需要学习 GitHub Actions 和 Codespaces 的使用方法

### 本地开发与部署

如果不使用 GitHub Codespaces，您仍然可以在本地开发和部署：

```bash
# 克隆仓库
git clone https://github.com/USERNAME/yt-dlp-docker.git
cd yt-dlp-docker

# 构建 Docker 镜像
docker build -t yt-dlp-docker .

# 运行容器
docker run -d \
  --name yt-dlp \
  -v ./yt-dlp/downloads:/downloads \
  -v ./yt-dlp/config:/config \
  yt-dlp-docker
``` 