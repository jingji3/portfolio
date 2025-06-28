# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# モダンなビルドシステム用のパス
Rails.application.config.assets.paths << Rails.root.join("app/assets/builds")

# 画像やフォント用のパスを正しく設定
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "images")
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "fonts")

# プリコンパイル対象を設定
Rails.application.config.assets.precompile += %w[*.png *.jpg *.jpeg *.gif *.svg *.eot *.ttf *.woff *.woff2]

# マニフェストファイルの場所を明示的に指定（必要な場合のみ）
Rails.application.config.assets.manifest = Rails.root.join("public", "assets", "manifest.json")

Rails.application.config.assets.precompile += %w[application.css]
