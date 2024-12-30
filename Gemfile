source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2.1"



gem "bootstrap", "~> 5.0"
gem "mysql2", ">= 0.5.3"  # Use MySQL as the database for Active Record
gem "sqlite3", ">= 1.4"    # Use SQLite3 for development (comment out if using MySQL)
gem "esbuild-rails"         # JavaScript bundling with ESBuild
gem "sprockets-rails"       # The original asset pipeline for Rails
gem "puma", ">= 5.0"        # Use the Puma web server
gem "importmap-rails"       # JavaScript with ESM import maps
gem "turbo-rails"           # Hotwire's SPA-like page accelerator
gem "stimulus-rails"        # Hotwire's modest JavaScript framework
gem "jbuilder"              # Build JSON APIs with ease
# gem "redis", ">= 4.0.1"   # Use Redis adapter to run Action Cable in production
# gem "kredis"              # Use Kredis for higher-level data types in Redis
gem "bcrypt", "~> 3.1.7"    # Active Model has_secure_password
gem "tzinfo-data", platforms: %i[mswin mingw jruby] # Time zone data
gem "bootsnap", require: false # Reduces boot times through caching
# gem "image_processing", "~> 1.2" # Active Storage variants

# Development and Test gems
group :development, :test do
  gem "debug", platforms: %i[mri mswin mingw], require: "debug/prelude"
  gem "brakeman", require: false # Static analysis for security vulnerabilities
  gem "rubocop-rails-omakase", require: false # Ruby styling
end

# Development gems
group :development do
  gem "web-console" # Use console on exception pages
end

# Test gems
group :test do
  gem "capybara"                # System testing
  gem "selenium-webdriver"      # Selenium for browser testing
end

# Additional gems
gem "iconv"                     # Character set conversion
gem "pry"                       # Enhanced shell for Ruby
gem "sassc-rails"              # SASS compiler for Rails
gem "jquery-rails"             # jQuery for Rails
gem "jquery-ui-rails"          # jQuery UI for Rails
gem "fullcalendar-rails"       # FullCalendar JavaScript library
gem "jquery-datetimepicker-rails" # jQuery DateTime Picker
gem "chartkick"                # Simple charts for Rails
gem "bootstrap-colorpicker-rails" # Bootstrap color picker
gem "font-awesome-rails"       # Font Awesome icons for Rails
gem "turbolinks"               # Makes navigating your web application faster
gem "mini_racer"               # A minimal V8 JavaScript engine
gem "prawn"                    # PDF generation
gem "prawn-table"              # Table support for Prawn
gem "paperclip", "~> 6.1"      # File attachment library for ActiveRecord
gem "activerecord-session_store", "~> 2.1" # Store sessions in the database
# gem "parser"                   # Ruby source and AST parser
# gem "unparser"                 # Unparser for Ruby AST
gem "rubocop"                  # Ruby static code analyzer
gem "rubocop-rails", require: false # RuboCop for Rails
gem "carrierwave"              # File uploads for Rails
# gem "rubocop-rspec", require: false # If using RSpec
gem "active_model_otp"         # Two-factor authentication support
gem "ckeditor"                 # Rich text editor
gem 'validates_overlap'
gem 'activerecord-import'