FROM golang:latest

# Install MinGW for Windows cross-compilation
RUN apt-get update && apt-get install -y gcc-mingw-w64

WORKDIR /app
COPY . .

# Build for Windows with correct compiler flags
ENV CC=x86_64-w64-mingw32-gcc
ENV CXX=x86_64-w64-mingw32-g++
ENV CGO_ENABLED=1
ENV GOOS=windows
ENV GOARCH=amd64
ENV CGO_CFLAGS="-g -O2 -I/usr/x86_64-w64-mingw32/include"
ENV CGO_CXXFLAGS="-g -O2 -I/usr/x86_64-w64-mingw32/include"
ENV CGO_LDFLAGS="-L/usr/x86_64-w64-mingw32/lib"

CMD ["go", "build", "-x", "-o", "dashboard.exe", "-ldflags=-H windowsgui", "."]
