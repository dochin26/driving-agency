# syntax=docker/dockerfile:1
FROM ruby:3.4.5

# 必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    npm \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Node.js 20.xをインストール（Hotwire/Stimulus用）
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Yarnをインストール
RUN npm install -g yarn

# 作業ディレクトリを設定
WORKDIR /app

# Gemfileをコピーして依存関係をインストール
COPY Gemfile Gemfile.lock ./
RUN bundle install

# package.jsonをコピーして依存関係をインストール
COPY package.json yarn.lock ./
RUN yarn install

# アプリケーションのコードをコピー
COPY . .

# アセットのプリコンパイル（本番環境用）
# 開発環境では不要だがDockerイメージに含めておく
# RUN bundle exec rails assets:precompile

# ポート3000を公開
EXPOSE 3000

# サーバーを起動
CMD ["rails", "server", "-b", "0.0.0.0"]
