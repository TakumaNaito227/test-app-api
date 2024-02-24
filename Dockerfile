# Ruby 3.0.0をベースイメージとして使用し、Alpine Linuxを採用。軽量でセキュリティに優れてる。
FROM ruby:3.0.0-alpine

# ビルド時の引数。`WORKDIR`（作業ディレクトリのパス）、実行時に必要なパッケージ、開発時にのみ必要なパッケージを指定します。
ARG WORKDIR
ARG RUNTIME_PACKAGES="nodejs tzdata postgresql-dev postgresql git"
ARG DEV_PACKAGES="build-base curl-dev"

# 環境変数を設定。`HOME`変数に作業ディレクトリのパスを設定し、言語設定とタイムゾーンを指定。
ENV HOME=/${WORKDIR} \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

# 作業ディレクトリを設定。このディレクトリがコマンドの実行場所になる。
WORKDIR ${HOME}

# ホストマシンからコンテナ内の作業ディレクトリへ`Gemfile`と`Gemfile.lock`をコピー。
COPY Gemfile* ./

# apkパッケージマネージャを使ってシステムを更新し、必要なパッケージをインストール。
# `gcompat`はGNU Cライブラリの互換レイヤー。
# `RUNTIME_PACKAGES`で指定された実行時に必要なパッケージをインストールし。
# `build-dependencies`という仮想パッケージグループを作成し、開発時にのみ必要なパッケージをインストール。
# `bundle install`でGemfileに記載された依存関係をインストール。
# 開発パッケージはインストール後に削除してイメージサイズを小さく保つ。
RUN apk update && \
    apk upgrade && \
	apk add --no-cache gcompat && \
    apk add --no-cache ${RUNTIME_PACKAGES} && \
    apk add --virtual build-dependencies --no-cache ${DEV_PACKAGES} && \
    bundle install -j4 && \
    apk del build-dependencies

# ホストマシンの現在のディレクトリ内のすべてのファイルをコンテナの作業ディレクトリにコピー。
COPY . .
