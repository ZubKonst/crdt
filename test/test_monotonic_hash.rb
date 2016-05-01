require_relative 'test_helper'
require_relative 'monotonic_hash_interface'

class TestMonotonicHash < Minitest::Test
  include MonotonicHashInterface

  def setup
    @hash = MonotonicHash.new('test-hash')
  end

end
