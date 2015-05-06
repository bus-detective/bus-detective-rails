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
gem 'active_model_serializers', '~> 0.8.3'
gem 'geokit-rails'
gem 'pg_search'

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
  gem 'sentry-raven'
end
