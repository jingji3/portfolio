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

# SolidQueueのテーブルが存在するか確認し、なければ作成
bundle exec rails runner "
  begin
    ActiveRecord::Base.connection.execute('SELECT 1 FROM solid_queue_jobs LIMIT 1')
    puts 'SolidQueue tables already exist'
  rescue ActiveRecord::StatementInvalid
    puts 'Creating SolidQueue tables...'
    require 'solid_queue/migration'
    SolidQueue::Migration.new.change
    puts 'SolidQueue tables created successfully'
  end
"
