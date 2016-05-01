require_relative 'test_helper'

class TestLWWSetPerformance < Minitest::Benchmark

  def setup
    @lww_sets =
      self.class.bench_range.each_with_object({}) do |n, hash|
        Redis.current.del("test#{n}:add_set", "test#{n}:remove_set")
        lww_set = LWWSet.new(store: :redis, namespace: "test#{n}")
        n.times { |i| lww_set.add("key_#{i}", rand(10000)) }
        n.times { |i| lww_set.remove("key_#{i+n/2}", rand(10000)) }
        hash[n] = lww_set
      end
  end

  def teardown
    self.class.bench_range.each do |n|
      Redis.current.del("test#{n}:add_set", "test#{n}:remove_set")
    end
  end

  def bench_element_assignment
    assert_performance_constant 0.999 do |n|
      @lww_sets[n].add('key_0', rand(10000))
    end
  end

  def bench_element_removing
    assert_performance_constant 0.999 do |n|
      @lww_sets[n].remove('key_0', rand(10000))
    end
  end

  def bench_element_existence
    assert_performance_constant 0.999 do |n|
      @lww_sets[n].exists?('key_0')
    end
  end

  def bench_all_elements_return
    assert_performance_linear 0.999 do |n|
      @lww_sets[n].get
    end
  end
end
