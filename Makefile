.PHONY: build-windows build-local run clean build-macos build-windows-docker install-docker

build-windows:
	@echo "Building for Windows..."
	@echo "Note: Direct cross-compilation might not work due to CGO limitations."
	@echo "Consider using Docker for cross-compilation or build directly on Windows."
	GOOS=windows GOARCH=amd64 CGO_ENABLED=1 \
	go build -o dashboard.exe -ldflags="-H windowsgui" .
	@echo "Windows build completed: dashboard.exe"

# Update Docker-based build option for Windows
build-windows-docker:
	@echo "Building for Windows using Docker..."
	docker run --rm -v "$(PWD)":/app -w /app golang:latest \
	bash -c "apt-get update && apt-get install -y gcc-mingw-w64 && \
	CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ \
	CGO_ENABLED=1 GOOS=windows GOARCH=amd64 \
	CGO_CFLAGS='-g -O2 -I/usr/x86_64-w64-mingw32/include' \
	CGO_CXXFLAGS='-g -O2 -I/usr/x86_64-w64-mingw32/include' \
	CGO_LDFLAGS='-L/usr/x86_64-w64-mingw32/lib' \
	go build -x -o dashboard.exe -ldflags='-H windowsgui' ."
	@echo "Windows build completed: dashboard.exe"

build-local:
	@echo "Building for local platform..."
	go build -o dashboard
	@echo "Local build completed"

# Add a macOS specific build
build-macos:
	@echo "Building for macOS..."
	GOOS=darwin GOARCH=amd64 go build -o dashboard-mac
	@echo "macOS build completed: dashboard-mac"

run:
	@echo "Running application..."
	go run main.go

clean:
	@echo "Cleaning up..."
	rm -f dashboard dashboard.exe

# Update macOS dependencies installation
install-deps-mac:
	@echo "Installing dependencies for cross-compilation on macOS..."
	@echo "Note: For CGO-based Windows builds, Docker is recommended instead."
	brew install mingw-w64

install-deps-linux:
	@echo "Installing mingw-w64 for cross-compilation on Linux..."
	sudo apt-get update
	sudo apt-get install -y gcc-mingw-w64

# Add a Docker installation guide
install-docker:
	@echo "Please install Docker Desktop from https://www.docker.com/products/docker-desktop"
	@echo "After installation, run 'make build-windows-docker' to build for Windows."
