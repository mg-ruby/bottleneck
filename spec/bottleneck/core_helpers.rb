module CoreHelpers
  def run_bottleneck
    Bottleneck::Core.new("127.0.0.1").run
  end

  def ok_result(result)
    check_is_hash(result)
    expect(result[:status]).to eq 200
    expect(result[:message]).to eq "ok"
  end

  def failed_result(result, seconds)
    check_is_hash(result)
    expect(result[:status]).to eq 429
    expect(result[:message]).to eq "Rate limit exceeded. Try again in #{seconds} seconds"
  end

  def check_is_hash(result)
    expect(result).to be_a Hash
  end
end
