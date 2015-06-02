source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails', '~> 4.2.0'

gem 'active_model_serializers', '~> 0.8.3' # Because people hate 0.9.x branch for the different API, and 0.10.x is built on 0.8
gem 'geokit-rails' # Provides acts_as_mappable
gem 'gtfs'         # Support for General Transit Feed Specification (format of the stop/route data)
gem 'http'
gem 'kaminari'
gem 'pg'
gem 'puma'
gem 'rack-cors', require: 'rack/cors'
gem 'redis'
gem 'redis-rails'           # For using Redis as the application cache
gem 'ruby-protocol-buffers' # Required for parsing GTFS data which is built in protocol buffers
gem 'sentry-raven'          # Error reporting service
gem 'skylight'              # Profiling and performance monitoring

group :development, :test do
  gem 'byebug'
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'pry'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'simplecov', require: false
  gem 'database_cleaner'
end

group :production do
  gem 'rails_12factor'
  gem 'uglifier'
end
