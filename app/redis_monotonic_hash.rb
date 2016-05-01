# A RedisMonotonicHash is a collection of unique keys and their values,
# where each value is nondecreasing.
# Redis is used to persist data.
#
class RedisMonotonicHash
  include Enumerable

  # RedisMonotonicHash.new(name)  -> new_redis_monotonic_hash
  #
  # Returns a new, empty monotonic hash.
  def initialize(name)
    @redis_key = name
    @write_lock = Mutex.new
  end

  # redis_monotonic_hash[key] = score    -> score or nil
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
    @write_lock.synchronize do
      current_score = redis.zscore(@redis_key, key)
      if !current_score || current_score < score
        redis.zadd(@redis_key, score, key)
        score
      end
    end
  end

  # redis_monotonic_hash[key]    -> score or nil
  #
  # == Element Reference
  #
  # Retrieves the score object corresponding to the key object.
  # If not found, returns nil.
  #
  def [](key)
    redis.zscore(@redis_key, key)
  end

  # redis_monotonic_hash.each {|key, value| block }
  #
  # Calls the given block once for each element in the set, passing
  # the element as parameter.  Returns an enumerator if no block is
  # given.
  # See also Enumerable.
  #
  def each
    all_entries.each {|key, value| yield key, value }
  end

  # redis_monotonic_hash.to_h -> hash
  #
  # Converts RedisMonotonicHash to a Hash object.
  #
  def to_h
    Hash[all_entries]
  end

  private

    def all_entries
      redis.zrange(@redis_key, 0, -1, with_scores: true)
    end

    def redis
      Redis.current
    end
end
