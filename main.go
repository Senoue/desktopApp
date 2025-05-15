package main

import (
	"embed"
	"fmt"
	"io/fs"
	"log"
	"net"
	"net/http"
	"os"
	"os/signal"
	"syscall"

	webview "github.com/webview/webview_go"
)

//go:embed dashbord.html
var content embed.FS

func main() {
	// HTTPサーバーを起動
	server := startServer()
	defer server.Close()

	// サーバーのアドレスを取得
	addr := server.Addr().String()
	url := fmt.Sprintf("http://%s", addr)

	// WebViewを作成
	w := webview.New(true)
	defer w.Destroy()
	w.SetTitle("ダッシュボード")
	w.SetSize(1200, 800, webview.HintNone)
	w.Navigate(url)
	w.Run()
}

// startServer は HTTP サーバーを起動し、リスナーを返します
func startServer() net.Listener {
	// 使用可能なポートを取得
	listener, err := net.Listen("tcp", "localhost:0")
	if err != nil {
		log.Fatal(err)
	}

	// ファイルシステムを設定
	fsys, err := fs.Sub(content, ".")
	if err != nil {
		log.Fatal(err)
	}

	// ハンドラーを設定
	http.Handle("/", http.FileServer(http.FS(fsys)))

	// サーバーを起動
	go func() {
		log.Printf("Server started at %s\n", listener.Addr().String())
		err := http.Serve(listener, nil)
		if err != nil && err != http.ErrServerClosed {
			log.Fatal(err)
		}
	}()

	// シグナル処理
	go func() {
		sigCh := make(chan os.Signal, 1)
		signal.Notify(sigCh, os.Interrupt, syscall.SIGTERM)
		<-sigCh
		log.Println("Shutting down server...")
		listener.Close()
	}()

	return listener
}
