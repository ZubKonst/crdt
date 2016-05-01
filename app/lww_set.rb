class LWWSet

  # LWWSet.new    -> new_lww_set
  #
  # Returns a new, empty LWW set.
  def initialize
    @add_set    = MonotonicHash.new
    @remove_set = MonotonicHash.new
  end

  # lww_ser.add(element, new_time)  -> lww_set
  #
  # Adds element and timestamp into MonotonicHash @add_set.
  #
  def add(element, new_time)
    @add_set[element] = new_time
    self
  end

  # lww_set.remove(element, new_time)  -> lww_set
  #
  # Adds element and timestamp into MonotonicHash @remove_set.
  #
  def remove(element, new_time)
    @remove_set[element] = new_time
    self
  end

  # lww_set.exists?(element)  -> true or false
  #
  # Returns true if the timestamp of the entry from @add_set is more recent than that of the entry from @remove_set.
  # Returns false if the element isn’t present, or the entry from @remove_set is newer than that from @add_set.
  #
  def exists?(element)
    add_time    = @add_set[element]
    return false unless add_time
    remove_time = @remove_set[element]
    return true unless remove_time
    add_time > remove_time
  end

  # lww_set.get  -> an_array
  #
  # Returns a new array populated with `existing` elements from this set.
  # `existing` elements are those elements that are present in @add_set without also being present in @remove_set,
  # or where the timestamp for the element in @add_set is newer than the timestamp for the element in @remove_set.
  #
  def get
    remove_times = @remove_set.to_h
    @add_set.to_a.select do |element, add_time|
      remove_time = remove_times[element]
      !remove_time || remove_time < add_time
    end.map(&:first)
  end

end
