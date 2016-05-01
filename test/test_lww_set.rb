require_relative 'test_helper'

class TestLWWSet < Minitest::Test

  def setup
    @lww_set = LWWSet.new
    @add_set    = @lww_set.instance_variable_get(:@add_set)
    @remove_set = @lww_set.instance_variable_get(:@remove_set)
  end

  def test_that_add_uses_add_set
    mock_sets!
    @add_set.expect :[]=, true, [:test_key, 42]
    @lww_set.add(:test_key, 42)
    @add_set.verify
  end

  def test_that_remove_uses_remove_set
    mock_sets!
    @remove_set.expect :[]=, true, [:test_key, 42]
    @lww_set.remove(:test_key, 42)
    @remove_set.verify
  end

  def test_entries_when_no_entries
    stub_sets!(nil, nil)
    assert !@lww_set.exists?(:test_key)
    assert_equal [], @lww_set.get
  end

  def test_entries_when_entry_added
    stub_sets!(rand(1000), nil)
    assert @lww_set.exists?(:test_key)
    assert_equal [:test_key], @lww_set.get
  end

  def test_entries_when_entry_just_removed
    stub_sets!(nil, rand(1000))
    assert !@lww_set.exists?(:test_key)
    assert_equal [], @lww_set.get
  end

  def test_entries_when_entry_added_and_removed
    stub_sets!(1, 2)
    assert !@lww_set.exists?(:test_key)
    assert_equal [], @lww_set.get
  end

  def test_entries_when_entry_removed_before_adding
    stub_sets!(2, 1)
    assert @lww_set.exists?(:test_key)
    assert_equal [:test_key], @lww_set.get
  end

  def test_sets_with_n_keys
    add_set = {}
    remove_set = {}
    result_keys = []

    100.times.each do |i|
      case rand
        when 0...0.25
          # just added
          result_keys << "key_#{i}"
          add_set["key_#{i}"] = rand(1000)
        when 0.25...0.5
          # just removed
          remove_set["key_#{i}"] = rand(1000)
        when 0.5...0.75
          # added and removed
          time = rand(1000)
          add_set["key_#{i}"] = time
          remove_set["key_#{i}"] = time + rand(1000)
        when 0.75...1
          # removed and added
          result_keys << "key_#{i}"
          time = rand(1000)
          add_set["key_#{i}"] = time + rand(1000)
          remove_set["key_#{i}"] = time
      end
    end
    @lww_set.instance_variable_set(:@add_set, add_set)
    @lww_set.instance_variable_set(:@remove_set, remove_set)

    assert_equal result_keys.sort, @lww_set.get.sort
  end

  private

  def mock_sets!
    @add_set = Minitest::Mock.new
    @remove_set = Minitest::Mock.new
    @lww_set.instance_variable_set(:@add_set, @add_set)
    @lww_set.instance_variable_set(:@remove_set, @remove_set)
  end

  def stub_sets!(add_set_value, remove_set_value)
    add_set = add_set_value ? {test_key: add_set_value} : {}
    @lww_set.instance_variable_set(:@add_set, add_set)

    remove_set = remove_set_value ? {test_key: remove_set_value} : {}
    @lww_set.instance_variable_set(:@remove_set, remove_set)
  end

end
