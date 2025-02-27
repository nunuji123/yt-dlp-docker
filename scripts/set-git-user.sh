#!/bin/bash

# 脚本用于设置Git提交人信息
# 使用: ./scripts/set-git-user.sh [name] [email]

# 默认值
DEFAULT_NAME=nunuji123@163.com
DEFAULT_EMAIL="nunuji123@163.com"

# 获取参数或使用默认值
GIT_USER_NAME=${1:-$DEFAULT_NAME}
GIT_USER_EMAIL=${2:-$DEFAULT_EMAIL}

# 仅为当前项目设置Git用户信息
git config user.name "$GIT_USER_NAME"
git config user.email "$GIT_USER_EMAIL"

echo "Git提交人已设置为:"
echo "名称: $GIT_USER_NAME"
echo "邮箱: $GIT_USER_EMAIL"
echo ""
echo "此设置仅适用于当前项目。如需全局设置，请使用 --global 选项。" 