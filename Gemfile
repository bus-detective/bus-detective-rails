source 'https://rubygems.org'

ruby '2.2.0'

gem 'rails', '4.2.0'
gem 'pg'
gem 'puma'
gem 'http'
gem 'rack-cors', require: 'rack/cors'
gem 'redis'
gem 'ruby-protocol-buffers'
gem 'gtfs'

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'database_cleaner'
end

group :production do
  gem 'uglifier'
  gem 'rails_12factor'
end
