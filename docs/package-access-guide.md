# GitHub Container Registry 访问权限配置指南

为了解决 `ERROR: failed to solve: failed to push ghcr.io/nunuji123/yt-dlp-docker:latest: unexpected status from POST request to https://ghcr.io/v2/nunuji123/yt-dlp-docker/blobs/uploads/: 403 Forbidden` 错误，请按照以下步骤配置您的GitHub仓库和Package权限：

## 1. 在仓库中启用改进的容器支持

1. 在GitHub仓库页面，点击"Settings" (设置) 选项卡
2. 在左侧菜单中，点击"Features" (功能)
3. 确保"Improved container support" (改进的容器支持) 已启用

## 2. 配置GitHub Actions工作流的权限

已在 `.github/workflows/deploy.yml` 文件中添加了以下权限配置：

```yaml
permissions:
  contents: read
  packages: write
```

这将授予GitHub Actions工作流读取仓库内容和写入包的权限。

## 3. 配置仓库级别的包访问权限

1. 在GitHub仓库页面，点击"Settings" (设置) 选项卡
2. 在左侧菜单中，点击"Actions" (操作)
3. 在"Workflow permissions" (工作流权限) 部分：
   - 选择 "Read and write permissions" (读写权限)
   - 确保 "Allow GitHub Actions to create and approve pull requests" (允许GitHub Actions创建和批准拉取请求) 已勾选
4. 点击 "Save" (保存) 按钮

## 4. 启用GitHub Packages

1. 在GitHub个人设置中，点击"Features"
2. 确保已启用"GitHub Packages"

## 5. 修改包的可见性设置（如果需要）

如果您希望您的包对公众可见：

1. 访问您的GitHub个人资料页面
2. 点击"Packages" (包) 选项卡
3. 找到并点击 `yt-dlp-docker` 包
4. 点击"Package settings" (包设置)
5. 在"Danger Zone" (危险区域) 中，将可见性从"Private" (私有) 更改为"Public" (公开)

## 6. 使用个人访问令牌（可选，如上述方法仍不解决问题）

如果以上方法仍然无法解决问题，您可以创建并使用个人访问令牌 (PAT)：

1. 访问您的GitHub个人设置
2. 点击"Developer settings" (开发者设置)
3. 点击"Personal access tokens" (个人访问令牌) → "Fine-grained tokens" (细粒度令牌)
4. 点击"Generate new token" (生成新令牌)
5. 为令牌提供描述性名称，例如 "yt-dlp-docker-ghcr"
6. 设置适当的权限：
   - 在"Repository access" (仓库访问) 部分选择 "Only select repositories" (仅选择的仓库)
   - 选择您的 yt-dlp-docker 仓库
   - 在"Repository permissions" (仓库权限) 部分：
     - Contents: Read
     - Packages: Read and write
7. 点击"Generate token" (生成令牌)
8. 复制生成的令牌

然后，在GitHub仓库中添加此令牌作为秘密：

1. 在GitHub仓库页面，点击"Settings" (设置) 选项卡
2. 在左侧菜单中，点击"Secrets and variables" (秘密和变量) → "Actions"
3. 点击"New repository secret" (新建仓库秘密)
4. 名称设为 `GHCR_PAT`
5. 值设为您刚才复制的个人访问令牌
6. 点击"Add secret" (添加秘密)

最后，修改工作流文件以使用这个令牌：

```yaml
- name: Login to GitHub Container Registry
  uses: docker/login-action@v2
  with:
    registry: ghcr.io
    username: ${{ github.repository_owner }}
    password: ${{ secrets.GHCR_PAT }}  # 使用PAT而不是GITHUB_TOKEN
```

按照上述步骤配置后，GitHub Actions应该能够成功推送镜像到GitHub Container Registry。 