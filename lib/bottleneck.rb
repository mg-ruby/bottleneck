require "bottleneck/version"
require "bottleneck/core"
require "yaml"
require "redis"
require "redis-namespace"

module Bottleneck
  class << self
    def check(ip)
      Core.new(ip).run
    end

    def storage
      init_storage
    end

    def redis_conn
      redis_conf = load_config("redis.yml")
      Redis.new(host: redis_conf["host"], port: redis_conf["port"])
    end

    # Init redis client from config
    def init_storage
      Redis::Namespace.new(:bottleneck, redis: redis_conn)
    end

    # Get limits from config
    def config
      load_config("bottleneck.yml")
    end

    private

    def load_config(file)
      # Check for Rails defined, or use current path
      root = (defined?(Rails) && Rails.respond_to?(:root) && Rails.root) || Dir.pwd
      path = "#{root}/config/#{file}"
      raise "No #{file} file found in your config directory!" unless File.exist?(path)
      YAML.load_file(path)
    end
  end
end
