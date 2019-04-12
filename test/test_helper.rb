$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "factory_bot/fixture_generator"
require "factory_bot"
require "factories"
require "postgresql"
require "models"

require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]

require "minitest/around"
require "minitest/spec"
require "minitest/autorun"

class Minitest::Spec
  #parallelize_me!

  attr_reader :recorder

  def around
    @recorder = FactoryBot::FixtureGenerator.reset_recorder!
    ActiveRecord::Base.transaction do
      yield
      raise ActiveRecord::Rollback
    end
  end
end

FactoryBot::FixtureGenerator.configure do |config|
  config.fixture_file = "./test/factory_fixtures.rb"
end

FactoryBot::FixtureGenerator.enable_recording!
FactoryBot::FixtureGenerator.load_fixtures!

Minitest.after_run do
  FactoryBot::FixtureGenerator.save_fixtures!
end
