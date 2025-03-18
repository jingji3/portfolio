#!/usr/bin/env bash
set -o errexit

# Install dependencies
bundle install

# Check for yarn.lock and perform JS/CSS builds if present
if [ -f yarn.lock ]; then
  yarn install
  # DaisyUIを確実にインストール
  yarn add daisyui
  # JavaScriptのビルド
  yarn build
  # CSSのビルド（watchモードなし）
  npx tailwindcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css
fi

# Precompile assets
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Run migrations
bundle exec rails db:migrate
