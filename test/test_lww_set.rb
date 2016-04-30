require_relative 'test_helper'

class TestLWWSet < Minitest::Test
  def setup
    @lww_set = LWWSet.new
  end

  def test_that_set_is_truthy
    assert @lww_set
  end
end