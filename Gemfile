source "https://rubygems.org"

ruby "3.4.5"

# Rails 8.1.1
gem "rails", "~> 8.1.2"

# PostgreSQL adapter
gem "pg", "~> 1.6"

# Puma web server
gem "puma", ">= 5.0"

# Asset pipeline
gem "sprockets-rails"

# Hotwire's SPA-like page accelerator
gem "turbo-rails"

# Hotwire's modest JavaScript framework
gem "stimulus-rails"

# Build JSON APIs with ease
gem "jbuilder"

# Use Kredis to get higher-level data types in Redis
# gem "kredis"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants
# gem "image_processing", "~> 1.2"

# Authentication
gem "devise", "~> 4.9"

# Tailwind CSS + daisyUI
gem "tailwindcss-rails", "~> 3.0"

# Error monitoring
gem "sentry-ruby"
gem "sentry-rails"

# Geocoding
gem "geocoder", "~> 1.8"

# Environment variables
gem "dotenv-rails", groups: [ :development, :test ]

# Pagination
gem "kaminari", "~> 1.2"

group :development, :test do
  # Debugging
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities
  gem "brakeman", require: false
  gem "bundler-audit", require: false

  # Omakase Ruby styling
  gem "rubocop-rails-omakase", require: false

  # Testing
  gem "rspec-rails", "~> 8.0"
  gem "factory_bot_rails", "~> 6.4"
  gem "faker", "~> 3.2"
end

group :development do
  # Use console on exceptions pages
  gem "web-console"

  # Add speed badges
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps
  # gem "spring"

  # Better error pages
  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  # Use system testing
  gem "capybara"
  gem "selenium-webdriver"

  # Test coverage
  gem "simplecov", require: false
end
