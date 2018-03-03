require "bottleneck/version"
require "bottleneck/core"
require "yaml"
require "redis"
require "redis-namespace"

module Bottleneck
  class << self
    # Run method call on Core object 
    #
    # @param [String] A name to uniquely identify this rate limit. For example, '127.0.0.1'
    def check(ip)
      Core.new(ip).run
    end

    # Init Redis Namespace storage
    #
    # @return [Redis::Namespace] Redis::Namespace instance  
    def storage
      init_storage
    end

    # Init Redis instance
    #
    # @return [Redis] Redis instance
    def redis_conn
      redis_conf = load_config("redis.yml")
      Redis.new(host: redis_conf["host"], port: redis_conf["port"])
    end

    # Init Redis Namespace storage
    #
    # @return [Redis::Namespace] Redis::Namespace instance  
    def init_storage
      Redis::Namespace.new(:bottleneck, redis: redis_conn)
    end

    # Load limits config file
    #
    # @return [Hash] Hash for bottleneck.yml file  
    def config
      load_config("bottleneck.yml")
    end

    private
    # Load config file
    #
    # @return [Hash] Hash with configuration
    def load_config(file)
      root = (defined?(Rails) && Rails.respond_to?(:root) && Rails.root) || Dir.pwd
      path = "#{root}/config/#{file}"
      raise "No #{file} file found in your config directory!" unless File.exist?(path)
      YAML.load_file(path)
    end
  end
end
