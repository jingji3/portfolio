FROM ruby:3.3.3

# Rails app lives here
WORKDIR /jingji_portfolio

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client watchman && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Node.jsの最新バージョンをインストール（v20系）
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

# Set production environment
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo

# JS依存関係をインストールするステップを追加
COPY package.json yarn.lock* ./
RUN yarn install --frozen-lockfile

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# TailwindCSSビルド
RUN yarn build:css

# Railsサーバー起動コマンド
CMD ["bin/dev"]
