source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.3'

# Rails
gem 'rails', '7.1.3.4'
gem "logger", "~> 1.5"

gem "propshaft"

# データベース
gem "pg", "~> 1.5"

# Webserver
gem "puma"

# JavaScript関連
gem "turbo-rails"
gem "stimulus-rails"

gem "jbuilder"

# アセット
gem 'jsbundling-rails'

# CSS関連
gem 'tailwindcss-rails'
gem 'cssbundling-rails'

# ファイルアップロード
gem 'aws-sdk-s3', require: false

# 画像処理
gem 'mini_magick'
gem 'active_storage_validations'

# キャッシュストア
gem 'redis', '~> 5.0'

# ログイン
gem 'sorcery', '~> 0.17.0'

# 言語対応
gem 'rails-i18n', '~> 7.0.10'

# 管理者
gem 'administrate'

# 検索機能
gem 'ransack'

# configuration
gem 'config'
gem 'dotenv-rails', require: 'dotenv/load'

# enum
gem 'enum_help'

# js系
gem 'jquery-rails'
gem 'select2-rails'

gem "tzinfo-data", platforms: %i[ jruby ]

gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false

gem 'net-protocol'
gem 'net-pop'
gem 'net-smtp'
gem 'net-imap'

gem 'uri'
gem 'digest'

gem 'concurrent-ruby', '1.3.4'

group :development, :test do

  # Code Analyze
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem 'scss_lint', require: false
  gem 'slim_lint'

  # test
  gem 'rspec-rails'
  gem 'factory_bot_rails'
end

group :development do
  gem "web-console"
  gem 'rack-mini-profiler'
  gem 'listen'
  gem 'spring'
end

group :test do
  gem "capybara"
  gem 'faker'
  gem "selenium-webdriver"
  gem 'webdrivers'
end
