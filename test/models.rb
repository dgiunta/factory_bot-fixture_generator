require 'active_record'

ENV['DATABASE_URL'] = 'postgresql://postgres:postgres@localhost:5433/factory_bot_fixture_generator_test'
ActiveRecord::Base.establish_connection

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

ActiveRecord::Schema.define do
  create_table :animals, force: true do |t|
    t.string :name
    t.references :kingdom
    t.timestamps
  end

  create_table :kingdoms, force: true do |t|
    t.string :name
    t.timestamps
  end
end

class Animal < ApplicationRecord
  belongs_to :kingdom
end

class Kingdom < ApplicationRecord
  has_many :animals
end

class Human
  attr_accessor :name

  def save!
    true
  end
end
