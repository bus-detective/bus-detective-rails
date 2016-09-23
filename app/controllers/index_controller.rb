class IndexController < ApplicationController
  REDIS_KEY_PREFIX = "bus-detective:index"

  force_ssl if: :ssl_configured?, except: [:letsencrypt]

  def show
    render text: redis.get("#{REDIS_KEY_PREFIX}:#{params[:revision] || current_index_key}")
  end

  def letsencrypt
    if params[:id] == 'gTrmpuvlhFtL3v0N2Rkhk9GBxkzXsnkfwyf_-XWRsj0'
      render text: 'gTrmpuvlhFtL3v0N2Rkhk9GBxkzXsnkfwyf_-XWRsj0.3agPbEGMW8yyXAdNJmtYhleq07pUgmnN1oCrhN9iRwA'
    else
      render text: '8BuARSATWEUgzbNUlNsz-RHS6WENQ2G9A6DbaPUwPNY.3agPbEGMW8yyXAdNJmtYhleq07pUgmnN1oCrhN9iRwA'
    end
  end

  private

  def current_index_key
    redis.get("#{REDIS_KEY_PREFIX}:current")
  end

  def redis
    @redis ||= Redis.new(url: ENV.fetch('REDISTOGO_URL', nil))
  end

  def ssl_configured?
    Rails.env.production?
  end
end
