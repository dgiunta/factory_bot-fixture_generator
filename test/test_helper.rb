$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "factory_bot/fixture_generator"
require "factory_bot"
require "postgresql"
require "factories"

require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]

require "minitest/around"
require "minitest/spec"
require "minitest/autorun"

require "active_record"

ENV['DATABASE_URL'] = 'postgresql://postgres:postgres@localhost:5433/factory_bot_fixture_generator_test'
ActiveRecord::Base.establish_connection

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

ActiveRecord::Schema.define do
  create_table :animals, force: true do |t|
    t.string :name
    t.timestamps
  end
end

class Animal < ApplicationRecord; end
class Human
  attr_accessor :name

  def save!
    true
  end
end

class Minitest::Spec
  include FactoryBot::Syntax::Methods

  def around
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
