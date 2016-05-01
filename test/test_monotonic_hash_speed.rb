require_relative 'test_helper'

class TestMonotonicHashSpeed < Minitest::Benchmark

  def setup
    @lww_sets = self.class.bench_range.each_with_object({}) do |n, hash|
      lww_set = MonotonicHash.new
      n.times { |i| lww_set["key_#{i}"] = rand(10000) }
      hash[n] = lww_set
    end
  end

  def bench_element_assignment
    assert_performance_constant 0.9999 do |n|
      @lww_sets[n]['key_0'] = rand(10000)
    end
  end

  def bench_element_reference
    assert_performance_constant 0.9999 do |n|
      @lww_sets[n]['key_0']
    end
  end

  def bench_all_elements_return
    assert_performance_constant 0.9999 do |n|
      @lww_sets[n].to_a
    end
  end
end
