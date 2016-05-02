class LWWSet

  # LWWSet.new(store: store, namespace: 'LWWSet')    -> new_lww_set
  #
  # Returns a new, empty LWW set.
  # Given store(:memory or :redis) will be used for persisting data.
  # Use namespaces to separate different LWWSet instances (it's important when you use :redis store).
  #
  def initialize(store: :memory, namespace: 'LWWSet')
    set_class =
      case store
        when :memory then MonotonicHash
        when :redis  then RedisMonotonicHash
        else raise "Unknown store '#{store}'"
      end

    @add_set    = set_class.new("#{namespace}:add_set")
    @remove_set = set_class.new("#{namespace}:remove_set")
  end

  # lww_ser.add(element, new_time)  -> lww_set
  #
  # Adds element and timestamp into MonotonicHash @add_set.
  #
  def add(element, new_time)
    @add_set[element] = new_time.to_i
    self
  end

  # lww_set.remove(element, new_time)  -> lww_set
  #
  # Adds element and timestamp into MonotonicHash @remove_set.
  #
  def remove(element, new_time)
    @remove_set[element] = new_time.to_i
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
    # TODO think about processing entries in batches
    remove_times = @remove_set.to_h
    @add_set.to_a.select do |element, add_time|
      remove_time = remove_times[element]
      !remove_time || remove_time < add_time
    end.map(&:first)
  end

end
