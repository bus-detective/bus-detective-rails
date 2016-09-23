class IndexController < ApplicationController
  REDIS_KEY_PREFIX = "bus-detective:index"

  def show
    render text: redis.get("#{REDIS_KEY_PREFIX}:#{params[:revision] || current_index_key}")
  end

  def letsencrypt
    render text: '8BuARSATWEUgzbNUlNsz-RHS6WENQ2G9A6DbaPUwPNY.3agPbEGMW8yyXAdNJmtYhleq07pUgmnN1oCrhN9iRwA'
  end

  private

  def current_index_key
    redis.get("#{REDIS_KEY_PREFIX}:current")
  end

  def redis
    @redis ||= Redis.new(url: ENV.fetch('REDISTOGO_URL', nil))
  end
end
