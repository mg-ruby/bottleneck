require "spec_helper"

RSpec.describe Bottleneck::Core do
  before :each do
    Bottleneck.redis_conn.flushdb
  end

  context "requests limit simulation" do
    it "should return 200 with ok" do
      ok_result(run_bottleneck)
    end

    it "should return 429 with error, when requests limit reached" do
      result = run_bottleneck
      3.times do
        result = run_bottleneck
      end
      failed_result(result, 3)
    end

    it "should return 429, when requests limit reached, but timer still going" do
      result = run_bottleneck
      3.times do
        result = run_bottleneck
      end
      sleep 2
      result = run_bottleneck
      failed_result(result, 1)
    end

    it "should return 200, when timer was reset" do
      result = run_bottleneck
      3.times do
        result = run_bottleneck
      end
      sleep 3
      result = run_bottleneck
      ok_result(result)
    end
  end
end
