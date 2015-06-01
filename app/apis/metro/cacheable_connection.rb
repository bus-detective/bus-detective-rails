module Metro
  class CacheableConnection
    def self.get(url, key, cache_opts)
      Rails.cache.fetch(key, cache_opts) do
        Rails.logger.warn("Cache expired, fetching: #{url}")
        Connection.get(url)
      end
    end
  end
end
