#!/usr/bin/env bash
# Vercel 构建脚本：先装 Dart Sass 和 Hugo，再编译站点。
# 版本号改动时，这里和本地环境保持一致。

set -euo pipefail

DART_SASS_VERSION=1.107.1
HUGO_VERSION=0.169.0
TZ=Asia/Shanghai
HUGO_CACHEDIR="${PWD}/.vercel/cache/hugo"

export TZ
export HUGO_CACHEDIR

build_temp_dir=$(mktemp -d)
trap 'rm -rf "$build_temp_dir"' EXIT SIGINT SIGTERM

mkdir -p "$HOME/.local"

echo "Installing Dart Sass ${DART_SASS_VERSION}..."
curl -sfL --output-dir "$build_temp_dir" -O \
  "https://github.com/sass/dart-sass/releases/download/${DART_SASS_VERSION}/dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz"
tar -C "$HOME/.local" -xf "${build_temp_dir}/dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz"
export PATH="$HOME/.local/dart-sass:${PATH}"

echo "Installing Hugo ${HUGO_VERSION}..."
curl -sfL --output-dir "$build_temp_dir" -O \
  "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_linux-amd64.tar.gz"
mkdir -p "$HOME/.local/hugo"
tar -C "$HOME/.local/hugo" -xf "${build_temp_dir}/hugo_${HUGO_VERSION}_linux-amd64.tar.gz"
export PATH="$HOME/.local/hugo:${PATH}"

# enableGitInfo 需要完整的提交历史，Vercel 的浅克隆补一下
git config --global core.quotepath false
if [ "$(git rev-parse --is-shallow-repository)" = "true" ]; then
  echo "Fetching full Git history..."
  git fetch --unshallow
fi

echo "Dart Sass: $(sass --version)"
echo "Hugo: $(hugo version)"

hugo build --gc --minify
