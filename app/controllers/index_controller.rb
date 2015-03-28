class IndexController < ApplicationController
  def show
    render text: redis.get(params[:revision] || current_index_key)
  end

  private

  def current_index_key
    redis.get('bus-detective:current')
  end

  def redis
    @redis ||= Redis.new(url: ENV.fetch('REDISTOGO_URL', nil))
  end
end
