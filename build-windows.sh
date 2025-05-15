#!/bin/bash
set -e

echo "Building Windows application using Docker..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Please install Docker first."
    echo "Visit https://www.docker.com/products/docker-desktop for installation."
    exit 1
fi

# Build using Docker with modified compiler flags
docker run --rm -v "$(pwd)":/app -w /app golang:latest \
    bash -c "apt-get update && apt-get install -y gcc-mingw-w64 && \
    CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ \
    CGO_ENABLED=1 GOOS=windows GOARCH=amd64 \
    CGO_CFLAGS='-g -O2 -I/usr/x86_64-w64-mingw32/include' \
    CGO_CXXFLAGS='-g -O2 -I/usr/x86_64-w64-mingw32/include' \
    CGO_LDFLAGS='-L/usr/x86_64-w64-mingw32/lib' \
    go build -x -o dashboard.exe -ldflags='-H windowsgui' ."

echo "Build completed. Output: dashboard.exe"
chmod +x dashboard.exe
