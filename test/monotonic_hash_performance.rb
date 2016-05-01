module MonotonicHashPerformance

  def bench_element_assignment
    assert_performance_constant 0.9999 do |n|
      @hashes[n]['key_0'] = rand(10000)
    end
  end

  def bench_element_reference
    assert_performance_constant 0.9999 do |n|
      @hashes[n]['key_0']
    end
  end

  def bench_all_elements_return
    assert_performance_constant 0.9999 do |n|
      @hashes[n].to_a
    end
  end

  private

    def generate_test_data!(hash_class)
      @hashes =
        self.class.bench_range.each_with_object({}) do |n, hash|
          m_hash = hash_class.new('test-speed')
          n.times { |i| m_hash["key_#{i}"] = rand(10000) }
          hash[n] = m_hash
        end
    end
end
