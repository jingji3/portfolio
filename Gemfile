source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.3'

# Rails
gem 'logger', '~> 1.5'
gem 'rails', '7.1.3.4'

gem 'propshaft'

# データベース
gem 'pg', '~> 1.5'

# Webserver
gem 'puma'

# JavaScript関連
gem 'stimulus-rails'
gem 'turbo-rails'

gem 'jbuilder'

# アセット
gem 'jsbundling-rails'

# CSS関連
gem 'cssbundling-rails'
gem 'tailwindcss-rails'

# ファイルアップロード
gem 'aws-sdk-s3', require: false

# 画像処理
gem 'active_storage_validations'
gem 'mini_magick'

# キャッシュストア
gem 'redis', '~> 5.0'

# ログイン
gem 'omniauth-google-oauth2'
gem 'sorcery'

# 言語対応
gem 'rails-i18n', '~> 7.0.10'

# 管理者
gem 'administrate'

# 検索機能
gem 'ransack'

# ページネーション
gem 'kaminari'

# configuration
gem 'config'
gem 'dotenv-rails', require: 'dotenv/load'

# enum
gem 'enum_help'

# js系
gem 'jquery-rails'

gem 'tzinfo-data', platforms: %i[jruby]

gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'

gem 'bootsnap', require: false
gem 'kamal', require: false
gem 'thruster', require: false

gem 'net-imap'
gem 'net-pop'
gem 'net-protocol'
gem 'net-smtp'

gem 'digest'
gem 'uri'

gem 'concurrent-ruby', '1.3.4'

group :development, :test do
  # Code Analyze
  gem 'brakeman', require: false
  gem 'rubocop-rails-omakase', require: false
  gem 'scss_lint', require: false
  gem 'slim_lint'

  # test
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :development do
  gem 'listen'
  gem 'rack-mini-profiler'
  gem 'spring'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'faker'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
