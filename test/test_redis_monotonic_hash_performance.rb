require_relative 'test_helper'
require_relative 'monotonic_hash_performance'

class TestRedisMonotonicHashPerformance < Minitest::Benchmark
  include MonotonicHashPerformance

  def setup
    generate_test_data!(RedisMonotonicHash)
  end
end
