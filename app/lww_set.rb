class LWWSet

  # LWWSet.new    -> new_lww_set
  #
  # Returns a new, empty LWW set.
  def initialize
    @add_set = {}
    @remove_set = {}
  end

  # hsh.add(element, new_time)  -> lww_set
  #
  # If there is already an entry for element, set its timestamp to new_time if new_time is more recent than the currently-stored timestamp.
  # Otherwise, insert a new entry consisting of the element and new_time.
  #
  def add(element, new_time)
    add_time = @add_set[element]
    if !add_time || new_time > add_time
      @add_set[element] = new_time
    end
    self
  end

  # hsh.remove(element, new_time)  -> lww_set
  #
  # If there is already an entry for element, set its timestamp to new_time if new_time is more recent than the currently-stored timestamp.
  # Otherwise, insert a new entry consisting of the element and new_time.
  #
  def remove(element, new_time)
    remove_time = [element]
    if !remove_time || new_time > remove_time
      @remove_set[element] = new_time
    end
    self
  end

end