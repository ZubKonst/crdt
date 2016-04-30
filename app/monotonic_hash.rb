# A MonotonicHash is a collection of unique keys and their values,
# where value for the specific key is nondecreasing.
#
class MonotonicHash
  include Enumerable

  # MonotonicHash.new    -> new_monotonic_hash
  #
  # Returns a new, empty monotonic hash.
  def initialize
    @hash = {}
  end

  # monotonic_hash[key] = score    -> score or nil
  #
  # == Element Assignment
  #
  # If there is already an entry for key, set its value to score if score is bigger than the currently-stored score.
  # Otherwise, insert a new entry consisting of the key and the given score.
  #
  # Returns score if the new score was assigned to an entry.
  # Returns nil if no changes were made.
  #
  def []=(key, score)
    current_score = @hash[key]
    if !current_score || current_score < score
      @hash[key] = score
    end
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

  # monotonic_hash.each {|key| block }
  #
  # Calls the given block once for each element in the set, passing
  # the element as parameter.  Returns an enumerator if no block is
  # given.
  def each
    @hash.each {|key| yield key}
  end

  # monotonic_hash.to_h -> hash
  #
  # Converts MonotonicHash to a Hash object.
  #
  def to_h
    @hash.dup
  end

end
