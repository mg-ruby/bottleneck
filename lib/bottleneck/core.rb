require "bottleneck/constants"

module Bottleneck
  class Core
    # Create a Core object.
    #
    # @param [String] ip A name to uniquely identify this rate limit. For example, '127.0.0.1'
    #
    # @return [Core] Core instance
    def initialize(ip)
      @ip = ip.to_s
      @storage = Bottleneck.storage
      @limits = Bottleneck.config["limits"]
    end

    # Run main logic initialization, set and read Redis keys and validation requests count and time limit.
    #
    # @return [Hash] Hash with :status and :message keys
    def run
      client_ip = @ip
      key = "request_count:#{client_ip}"
      result = { status: Constants::SUCCESS_STATUS, message: Constants::OK_MESSAGE }
      requests_count = @storage.get(key)
      unless requests_count
        @storage.set(key, 0)
        @storage.expire(key, @limits["time_period_seconds"])
      end
      if requests_count.to_i >= @limits["max_requests_count"]
        result[:status] = Constants::EXPIRED_STATUS
        result[:message] = message(period(key))
      else
        @storage.incr(key)
      end
      result
    end

    private

    # Get remaining time in seconds for key.
    #
    # @param [String]   key A unique key in Redis store
    #
    # @return [Integer] Countdown in seconds
    def period(key)
      @storage.ttl(key)
    end

    # Return string message for 429 status
    #
    # @param [Integer]   secs Remaining seconds
    #
    # @return [String] Rate limit message with seconds   
    def message(secs)
      "Rate limit exceeded. Try again in #{secs} seconds"
    end
  end
end
