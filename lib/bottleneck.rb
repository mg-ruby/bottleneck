require "bottleneck/version"
require "bottleneck/core"
require "yaml"
require "redis"

module Bottleneck
  class << self
    def check(request)
      Core.new(request).run
    end

    def storage
      init_storage
    end

    # Init redis client from config
    def init_storage
      redis_conf = load_config("redis.yml")
      Redis.new(host: redis_conf["host"], port: redis_conf["port"])
    end

    # Get limits from config
    def config
      load_config("bottleneck.yml")
    end

    private

    def load_config(file)
      path = File.join(Rails.root, "config", file)
      raise "No #{file} file found in your config directory!" unless File.exist?(path)
      YAML.load_file(path)
    end
  end
end
