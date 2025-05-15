@echo off
echo Building Windows application...

set GOOS=windows
set GOARCH=amd64
set CGO_ENABLED=1

go build -o dashboard.exe -ldflags="-H windowsgui" .

echo Build completed. Output: dashboard.exe
