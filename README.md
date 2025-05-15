# ダッシュボードアプリケーション

このアプリケーションは、Goの`webview`パッケージを使用したシンプルなデスクトップアプリケーションです。HTML/CSS/JavaScriptで作成されたダッシュボードをデスクトップアプリとして表示します。

## 機能

- 埋め込みHTMLコンテンツをレンダリング
- デスクトップウィンドウでの表示（サイズ: 1600x1000ピクセル）
- 内蔵HTTPサーバーによるコンテンツ配信

## 必要条件

- Go 1.16以上
- [webview/webview_go](https://github.com/webview/webview_go)の依存関係

### プラットフォーム別の依存関係

#### Windows
- Microsoft Edge WebView2 ランタイム
- MSVC ビルドツール

#### macOS
- Cocoa フレームワーク
- WebKit フレームワーク

#### Linux
- GTK 3
- WebKit2GTK

## ビルド方法

### 通常のビルド

```bash
go build -o dashboard .
```

### macOS用アプリバンドルの作成

コンソールウィンドウを表示せずにアプリケーションを実行するには、以下のスクリプトを使用してください:

```bash
./build_mac.sh
```

これにより`Dashboard.app`が作成され、通常のmacOSアプリケーションとして動作します。

### Windows用ビルド（コンソールなし）

```bash
go build -ldflags -H=windowsgui -o app.exe .
```

## 使用方法

アプリケーションを起動すると、埋め込みのHTMLコンテンツが表示されたウィンドウが開きます。

## プロジェクト構成

- `main.go` - メインアプリケーションコード
- `dashboard.html` - 埋め込みHTMLコンテンツ
- `build_mac.sh` - macOS用アプリバンドル作成スクリプト

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。
