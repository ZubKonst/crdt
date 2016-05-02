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
  end

  # redis_monotonic_hash[key] = score    -> score
  #
  # == Element Assignment
  #
  # If there is already an entry for key, set its value to score if score is bigger than the currently-stored score.
  # Otherwise, insert a new entry consisting of the key and the given score.
  #
  def []=(key, score)
    update_condition = ->(redis) do
      current_score = redis.zscore(@redis_key, key)
      !current_score || current_score < score
    end
    update_action = ->(redis) do
      redis.zadd(@redis_key, score, key)
    end
    redis_safe_update([@redis_key], update_condition, update_action)
    score
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
    # TODO use ZSCAN to process entries in batches
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

    # Optimistic locking using check-and-set
    # http://redis.io/topics/transactions
    #
    def redis_safe_update(keys, update_condition, update_action)
      redis.watch(keys) do
        if update_condition.call(redis)
          result = redis.multi do |multi|
            update_action.call(multi)
          end
          if result.nil?
            raise 'Transaction aborted due to a race condition. Try again.'
          end
        else
          redis.unwatch
        end
      end
      true
    end
end
