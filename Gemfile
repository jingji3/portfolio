source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.3'

# Rails本体
gem "rails", "7.1.3.4"

gem "propshaft"

# データベース
gem "pg", "~> 1.5"

# Webserver
gem "puma"

# JavaScript関連
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"

gem "jbuilder"

# アセット
gem 'jsbundling-rails'

# ファイルアップロード
gem 'aws-sdk-s3', require: false

# キャッシュストア
gem 'redis', '~> 5.0'

# CSS関連
gem 'tailwindcss-rails'

# 認証
# gem 'devise'

# configuration
gem 'config'
gem 'dotenv-rails', require: 'dotenv/rails-now'


gem "tzinfo-data", platforms: %i[ jruby ]


gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false


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
