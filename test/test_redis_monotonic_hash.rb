require_relative 'test_helper'
require_relative 'monotonic_hash_interface'

class TestRedisMonotonicHash < Minitest::Test
  include MonotonicHashInterface

  def setup
    clear_redis
    @hash = RedisMonotonicHash.new(redis_key)
  end

  def teardown
    clear_redis
  end

  private

    def redis_key
      'test-zset'
    end

    def clear_redis
      Redis.current.del(redis_key)
    end

end
