require_relative 'test_helper'

class TestMonotonicHash < Minitest::Test

  def setup
    @lww_set = MonotonicHash.new
  end

  def test_empty_hash
    assert_nil @lww_set[:key]
  end

  def test_simple_adding
    random_number = rand(1000)

    @lww_set[:key] = random_number

    assert_equal random_number, @lww_set[:key]
    assert_nil @lww_set[:different_key]

    assert_equal [[:key, random_number]], @lww_set.to_a
    assert_equal({key: random_number}, @lww_set.to_h)
  end

  def test_simple_adding_of_two_keys
    random_number1 = rand(1000)
    random_number2 = rand(1000)

    @lww_set[:key1] = random_number1
    @lww_set[:key2] = random_number2

    assert_nil @lww_set[:different_key]

    assert_equal [[:key1, random_number1],[:key2, random_number2]].sort, @lww_set.to_a.sort
    assert_equal({key1: random_number1, key2: random_number2}, @lww_set.to_h)
  end

  def test_adding_two_sequential_values
    first_score = rand(1000)
    second_score = first_score + rand(1000)

    @lww_set[:key] = first_score
    @lww_set[:key] = second_score

    assert_equal second_score, @lww_set[:key]
  end

  def test_adding_two_non_sequential_values
    first_score = 1000 + rand(1000)
    second_score = first_score - 1000

    @lww_set[:key] = first_score
    @lww_set[:key] = second_score

    assert_equal first_score, @lww_set[:key]
  end

end
