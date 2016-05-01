require_relative 'test_helper'
require_relative 'monotonic_hash_performance'

class TestMonotonicHashPerformance < Minitest::Benchmark
  include MonotonicHashPerformance

  def setup
    generate_test_data!(MonotonicHash)
  end
end
