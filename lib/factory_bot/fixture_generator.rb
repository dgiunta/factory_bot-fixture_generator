require 'pry'
require 'digest'
require "factory_bot"
require "factory_bot/fixture_generator/configuration"
require "factory_bot/fixture_generator/factory_methods"
require "factory_bot/fixture_generator/fixture_writer"
require "factory_bot/fixture_generator/recorder"
require "factory_bot/fixture_generator/version"

module FactoryBot
  module FixtureGenerator
    class << self
      attr_writer :recorder

      def config
        @config ||= Configuration.new
      end

      def configure(&block)
        block.call(config)
      end

      def enable_recording!
        FactoryGirl.extend FactoryMethods rescue nil
        FactoryBot.extend FactoryMethods
      end

      def load_fixtures!
        start = Time.now
        print "[FixtureBot::FixtureGenerator] Loading fixtures from #{config.fixture_file}..."
        load config.fixture_file if File.exist?(config.fixture_file)
        puts "done. (#{Time.now - start}s)"
      end

      def save_fixtures!
        FixtureWriter.new(recorder).save!(config.fixture_file)
      end

      def recorder
        @recorder ||= Recorder.new
      end

      def reset_recorder!
        @recorder = Recorder.new
      end
    end
  end
end
