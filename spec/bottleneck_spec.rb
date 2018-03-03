require "spec_helper"

RSpec.describe Bottleneck do
  context "config reading" do
    it "should read bottleneck.yml" do
      expect(Bottleneck.config).to be_a Hash
    end
  end

  context "storage initialization" do
    it "should init redis connection" do
      expect(Bottleneck.redis_conn).to be_a Redis
    end

    it "should init redis storage" do
      expect(Bottleneck.storage).to be_a Redis::Namespace
    end
  end
end
