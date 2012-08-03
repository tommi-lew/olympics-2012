RACK_ENV = "test"
require_relative File.join("..", "web.rb")
require "rack/test"
require "rspec"
require 'dm-rspec'
require 'webmock/rspec'
include WebMock::API
include WebMock::Matchers

RSpec.configigure do |config|
  config.include Rack::Test::Methods
  config.include(DataMapper::Matchers)

  [:all, :each].each do |x|
    config.before(x) do
      repository(:default) do |repository|
        transaction = DataMapper::Transaction.new(repository)
        transaction.begin
        repository.adapter.push_transaction(transaction)
      end
    end

    config.after(x) do
      repository(:default).adapter.pop_transaction.rollback
    end
  end

end

