module MonotonicHashInterface

  def test_empty_hash
    assert_nil @hash['test_key']
  end

  def test_simple_adding
    random_number = rand(1000)

    @hash['test_key'] = random_number

    assert_equal random_number, @hash['test_key']
    assert_nil @hash[:different_key]

    assert_equal [['test_key', random_number]], @hash.to_a
    assert_equal({'test_key' => random_number}, @hash.to_h)
  end

  def test_simple_adding_of_two_keys
    random_number1 = rand(1000)
    random_number2 = rand(1000)

    @hash['test_key_1'] = random_number1
    @hash['test_key_2'] = random_number2

    assert_nil @hash[:different_key]

    assert_equal [['test_key_1', random_number1],['test_key_2', random_number2]].sort, @hash.to_a.sort
    assert_equal({'test_key_1' => random_number1, 'test_key_2' => random_number2}, @hash.to_h)
  end

  def test_adding_two_sequential_values
    first_score = rand(1000)
    second_score = first_score + rand(1000)

    @hash['test_key'] = first_score
    @hash['test_key'] = second_score

    assert_equal second_score, @hash['test_key']
  end

  def test_adding_two_non_sequential_values
    first_score = 1000 + rand(1000)
    second_score = first_score - 1000

    @hash['test_key'] = first_score
    @hash['test_key'] = second_score

    assert_equal first_score, @hash['test_key']
  end

end
