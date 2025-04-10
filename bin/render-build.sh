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
  yarn build:css
fi

# アセットのPrecompile
bundle exec rails assets:precompile
bundle exec rails assets:clean

# migrations
bundle exec rake db:migrate

bundle exec rails runner "
  user = User.find_by(email: 'fsyuppoppos@gmail.com')
  if user
    user.update(role: 'admin')
    puts '管理者権限を付与しました: ' + user.email
  else
    puts '指定したメールアドレスのユーザーが見つかりません'
  end
"
