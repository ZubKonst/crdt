unless ENV['DISABLE_COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

require_relative '../app'
require 'minitest/autorun'
require 'minitest/benchmark' unless ENV['DISABLE_BENCH']
