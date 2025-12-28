# Docker環境構築

プロジェクトのDocker環境をセットアップするための設定ファイルを生成してください。

## 要件

1. **Dockerfile**
   - Ruby 3.4.5
   - Node.js（Hotwire/Stimulus用）
   - PostgreSQLクライアント

2. **docker-compose.yml**
   - web サービス（Rails）
   - db サービス（PostgreSQL 15）
   - ボリューム設定（gem, node_modules, postgres_data）
   - ポート設定（3000:3000）

3. **環境変数**
   - DATABASE_URL
   - RAILS_ENV
   - GOOGLE_MAPS_API_KEY（開発時はダミー）

4. **開発効率化**
   - ホットリロード対応
   - bindマウントでコード変更を即反映

## 出力形式

以下のファイルを生成してください：
- Dockerfile
- docker-compose.yml
- .dockerignore
- 開発用のセットアップ手順（README_DOCKER.md）

例：
```dockerfile
# Dockerfile
FROM ruby:3.4.5

RUN apt-get update -qq && apt-get install -y \
  nodejs \
  postgresql-client \
  build-essential

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["rails", "server", "-b", "0.0.0.0"]
```

```yaml
# docker-compose.yml
version: '3.8'

services:
  db:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data

  web:
    build: .
    command: bundle exec rails s -b 0.0.0.0
    volumes:
      - .:/app
      - gem_cache:/usr/local/bundle
    ports:
      - "3000:3000"
    depends_on:
      - db
    environment:
      DATABASE_URL: postgresql://postgres:password@db:5432/driving_agency_development

volumes:
  postgres_data:
  gem_cache:
```
