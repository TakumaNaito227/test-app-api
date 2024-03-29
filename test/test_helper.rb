ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# gem minitest-reporters setup
require "minitest/reporters"
Minitest::Reporters.use!

module ActiveSupport
  class TestCase

  # プロセスが分岐した直後に呼び出し
  parallelize_setup do |worker|
    load "#{Rails.root}/db/seeds.rb"
  end

    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Add more helper methods to be used by all tests here...
  end
end
