if defined?(Raven)
  Raven.configure do |config|
    config.dsn = ENV.fetch("SENTRY_ENDPOINT")
  end
end
