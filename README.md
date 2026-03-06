# もけ寄生

[Gleam](https://gleam.run) + [Lustre](https://lustre.build) のシンプルなプロジェクトです．Cloudflare Pages にホスティングします．

Gleam が JavaScript にコンパイルされて，ブラウザ上で動作 (CSR) します．

## 開発

```sh
# 依存関係のインストール
gleam deps download

# 開発サーバの起動
gleam run -m lustre/dev -- start 

# テストの実行
gleam test

# コードのフォーマット
gleam format src test
```

## ビルド・デプロイ

```sh
# dist/ にビルド
gleam run -m lustre/dev -- build 
```

`main` ブランチへの push で GitHub Actions が自動的にビルドし Cloudflare Pages にデプロイします．
