# ダッシュボードアプリケーション

CSVデータをロードして表示するダッシュボードアプリケーション。

## 必要なもの

- Go 1.16以上
- Dockerによるクロスコンパイル用にDockerがインストールされていること

## ビルド方法

### Dockerを使用したWindows向けビルド（推奨）

```bash
# スクリプトを実行可能にする
chmod +x build-windows.sh

# ビルドを実行
./build-windows.sh
```

または:

```bash
make build-windows-docker
```

### ローカル環境向けビルド

```bash
make build-local
```

### macOS向けビルド

```bash
make build-macos
```

### 実行

```bash
make run
```

## 注意点

- WebViewライブラリはCGOを使用するため、クロスコンパイルには適切なツールチェーンが必要です
- クロスコンパイルの複雑さを避けるため、Dockerを使用したビルドを推奨します
- Windows向けビルドでエラーが発生する場合は、Windows環境で直接ビルドするか、下記の代替案を検討してください

## 代替案

1. **Windows環境でビルドする**: WSL2やWindowsネイティブのGo環境を使用します
2. **別のライブラリを検討する**: WebViewの代わりにLorca（https://github.com/zserge/lorca）などのCGOに依存しないUIフレームワークを使用する
3. **静的HTMLとブラウザを使用する**: ローカルのHTMLファイルを開くシンプルなアプリケーションとして実装する

## トラブルシューティング

ビルド中に以下のようなエラーが発生する場合:
```
g++: error: unrecognized command-line option '-m64'
g++: error: unrecognized command-line option '-mthreads'
```

これはクロスコンパイラとwebviewライブラリの互換性の問題です。修正したビルドスクリプトを使用するか、Windows環境で直接ビルドしてください。
