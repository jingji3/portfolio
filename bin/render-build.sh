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

  mkdir -p public/assets
  cp -f app/assets/builds/tailwind.css public/assets/
  cp -f app/assets/builds/application.css public/assets/ 2>/dev/null || true
  cp -f app/assets/builds/application.js public/assets/
  cp -f app/assets/builds/theme_switcher.js public/assets/
fi

# アセットのPrecompile
# bundle exec rails assets:precompile
# bundle exec rails assets:clean

# migrations
bundle exec rails db:migrate
