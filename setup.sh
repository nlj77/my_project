#!/bin/bash
set -e

echo "1️⃣ Remove all pg gems and Bundler cache"
gem uninstall pg -a -x || true
bundle clean --force
rm -rf vendor/bundle

echo "2️⃣ Install system dependencies for Postgres and build tools"
sudo apt update
sudo apt install -y build-essential libpq-dev postgresql postgresql-contrib wget git curl

echo "3️⃣ Ensure PostgreSQL user exists (peer auth)"
sudo -u postgres psql -c "CREATE ROLE $USER WITH LOGIN CREATEDB;" || true

echo "4️⃣ Reinstall pg gem from source"
gem install pg --platform=ruby -- --with-pg-config=/usr/bin/pg_config

echo "5️⃣ Rebundle Rails project"
bundle install --force

echo "6️⃣ Restart PostgreSQL"
sudo systemctl restart postgresql

echo "7️⃣ Create and migrate database"
rails db:drop db:create db:migrate || true

echo "8️⃣ Install RSpec"
bundle exec rails generate rspec:install || true

echo "9️⃣ Install Google Chrome"
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

echo "🔟 Setup GitHub credentials"
git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"

echo "✅ Setup complete. Test Rails, RSpec, and Chrome."
