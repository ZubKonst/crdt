require 'simplecov'
SimpleCov.start

require_relative '../app'
require 'minitest/autorun'
require 'minitest/benchmark' unless ENV['DISABLE_BENCH']
