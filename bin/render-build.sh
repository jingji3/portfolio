#!/usr/bin/env bash
set -o errexit

# Install dependencies
bundle install

# Check for yarn.lock and perform JS/CSS builds if present
if [ -f yarn.lock ]; then
  yarn install
  yarn build
  yarn build:css
fi

# Precompile assets
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Run migrations
bundle exec rails db:migrate
