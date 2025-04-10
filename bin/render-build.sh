#!/usr/bin/env bash
set -o errexit

# Install dependencies
bundle install

# Check for yarn.lock and perform JS/CSS builds if present
if [ -f yarn.lock ]; then
  # パッケージのインストール
  yarn install
  # 各アセットを独立してビルド
  yarn build:js
  yarn build:css || echo "Sass build failed, but continuing..."
fi

# アセットのPrecompile
bundle exec rails assets:precompile
bundle exec rails assets:clean

# migrations
bundle exec rails db:migrate
