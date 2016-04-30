class LWWSet

  # LWWSet.new    -> new_lww_set
  #
  # Returns a new, empty LWW set.
  def initialize
    @add_set    = MonotonicHash.new
    @remove_set = MonotonicHash.new
  end

  # hsh.add(element, new_time)  -> lww_set
  #
  # Add element into MonotonicHash @add_set.
  #
  def add(element, new_time)
    @add_set[element] = new_time
    self
  end

  # hsh.remove(element, new_time)  -> lww_set
  #
  # Add element into MonotonicHash @remove_set.
  #
  def remove(element, new_time)
    @remove_set[element] = new_time
    self
  end

end