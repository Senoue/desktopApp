#!/bin/bash
set -e

echo "Building Windows application..."

# コンパイラの存在確認
check_compiler() {
  if ! command -v x86_64-w64-mingw32-gcc &> /dev/null; then
    echo "MinGW compiler not found. You need to install it first."
    
    if [ "$(uname)" == "Darwin" ]; then
      echo "On macOS, run: brew install mingw-w64"
      echo "Would you like to install it now? (y/n)"
      read -r answer
      if [ "$answer" == "y" ]; then
        brew install mingw-w64
        if [ $? -ne 0 ]; then
          echo "Installation failed. Falling back to Docker build."
          return 1
        fi
      else
        echo "Falling back to Docker build."
        return 1
      fi
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
      echo "On Ubuntu/Debian, run: sudo apt-get install gcc-mingw-w64"
      echo "On Fedora, run: sudo dnf install mingw64-gcc"
      echo "Falling back to Docker build."
      return 1
    else
      echo "Falling back to Docker build."
      return 1
    fi
  fi
  return 0
}

# Dockerを使ったビルド
docker_build() {
  if ! command -v docker &> /dev/null; then
    echo "Docker not found. Please install Docker to continue."
    echo "Visit https://www.docker.com/products/docker-desktop for installation."
    exit 1
  fi
  
  echo "Building with Docker..."
  docker run --rm -v "$(pwd)":/app -w /app golang:latest \
    bash -c "apt-get update && apt-get install -y gcc-mingw-w64 && \
    CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ \
    CGO_ENABLED=1 GOOS=windows GOARCH=amd64 \
    CGO_CFLAGS='-g -O2' \
    CGO_CXXFLAGS='-g -O2' \
    go build -o dashboard.exe -ldflags='-H windowsgui' ."
}

# メインプロセス
if check_compiler; then
  # MinGWを使用したビルド
  if [ "$(uname)" == "Darwin" ]; then
    # macOS用設定
    export CC=x86_64-w64-mingw32-gcc
    export CXX=x86_64-w64-mingw32-g++
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Linux用設定
    export CC=x86_64-w64-mingw32-gcc
    export CXX=x86_64-w64-mingw32-g++
  fi

  export GOOS=windows
  export GOARCH=amd64
  export CGO_ENABLED=1

  go build -o dashboard.exe -ldflags="-H windowsgui" .
else
  # Dockerを使用したビルド
  docker_build
fi

if [ -f "dashboard.exe" ]; then
  echo "Build completed. Output: dashboard.exe"
else
  echo "Build failed."
  exit 1
fi
