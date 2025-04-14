#!/usr/bin/env bash
# frozen modeを解除
bundle config set --local frozen false

set -o errexit

# Install dependencies
bundle install

# Check for yarn.lock and perform JS/CSS builds if present
if [ -f yarn.lock ]; then
  # パッケージのインストール
  yarn install
  # 各アセットを独立してビルド
  yarn build:js
  yarn build:css
fi

# アセットのPrecompile
bundle exec rails assets:precompile
bundle exec rails assets:clean

# migrations
# ナミクエーションファイルが存在するか確認
bundle exec rails generate solid_queue:install

# 通常のマイグレーションを実行
bundle exec rails db:migrate
