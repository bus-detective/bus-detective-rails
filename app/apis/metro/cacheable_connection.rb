module Metro
  class CacheableConnection
    def self.get(url, key, cache_opts)
      Rails.cache.fetch(key, cache_opts) do
        Connection.get(url)
      end
    end
  end
end
