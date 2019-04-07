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

factory_fixtures_file = File.join(File.dirname(__FILE__), "factory_fixtures.rb")
load factory_fixtures_file if File.exist?(factory_fixtures_file)
