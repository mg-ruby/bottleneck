require "bottleneck/constants"

module Bottleneck
  class Core
    def initialize(request)
      @ip = request.remote_ip.to_s
      @storage = Bottleneck.storage
      @limits = Bottleneck.config["limits"]
    end

    def run
      client_ip = @ip
      # create key in redis, based on client's IP
      key = "request_count:#{client_ip}"
      result = { status: Constants::SUCCESS_STATUS, message: Constants::OK_MESSAGE }
      requests_count = @storage.get(key)
      unless requests_count
        @storage.set(key, 0)
        @storage.expire(key, @limits["time_period_seconds"])
      end
      if requests_count.to_i >= @limits["max_requests_count"]
        result["status"] = Constants::EXPIRED_STATUS
        result["message"] = message(period(key))
      else
        @storage.incr(key)
      end
      result
    end

    private

    def period(key)
      # get remaining seconds with TTL from redis
      @storage.ttl(key)
    end

    def message(secs)
      "Rate limit exceeded. Try again in #{secs} seconds"
    end
  end
end
