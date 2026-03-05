# もけ寄生

[Gleam](https://gleam.run) + [Lustre](https://lustre.build) のシンプルなプロジェクトです．Cloudflare Pages に SSG でデプロイします．

## 開発

```sh
# 依存関係のインストール
gleam deps download

# 開発サーバの起動
gleam run -m lustre/dev -- dev 

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
