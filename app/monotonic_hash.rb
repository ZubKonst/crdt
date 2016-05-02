# A MonotonicHash is a collection of unique keys and their values,
# where each value is nondecreasing.
# Memory is used to persist data.
#
class MonotonicHash
  include Enumerable

  # MonotonicHash.new(name)  -> new_monotonic_hash
  #
  # Returns a new, empty monotonic hash.
  def initialize(name)
    @name = name
    @hash = {}
    @write_lock = Mutex.new
  end

  # monotonic_hash[key] = score    -> score
  #
  # == Element Assignment
  #
  # If there is already an entry for key, set its value to score if score is bigger than the currently-stored score.
  # Otherwise, insert a new entry consisting of the key and the given score.
  #
  def []=(key, score)
    @write_lock.synchronize do
      current_score = @hash[key]
      if !current_score || current_score < score
        @hash[key] = score
      end
    end
    score
  end

  # monotonic_hash[key]    -> score or nil
  #
  # == Element Reference
  #
  # Retrieves the score object corresponding to the key object.
  # If not found, returns nil.
  #
  def [](key)
    @hash[key]
  end

  # monotonic_hash.each {|key, value| block }
  #
  # Calls the given block once for each element in the set, passing
  # the element as parameter.  Returns an enumerator if no block is
  # given.
  # See also Enumerable.
  #
  def each
    @hash.each {|key, value| yield key, value }
  end

  # monotonic_hash.to_h -> hash
  #
  # Converts MonotonicHash to a Hash object.
  #
  def to_h
    @hash.dup
  end
end
