require 'pry'
require 'digest'
require "factory_bot"
require "factory_bot/fixture_generator/version"
require "factory_bot/fixture_generator/recorder"
require "factory_bot/fixture_generator/fixture_writer"

module FactoryBot
  module FixtureGenerator
    module FactoryMethods
      def create(factory_name, *args)
        FixtureGenerator.recorder.record(factory_name, *args) do
          super(factory_name, *args)
        end
      end
    end

    class Configuration
      attr_writer :fixture_file

      def fixture_file
        @fixture_file ||= File.join()
      end
    end

    class << self
      def config
        @config ||= Configuration.new
      end

      def configure(&block)
        block.call(config)
      end

      def enable_recording!
        FactoryBot.extend FactoryMethods
      end

      def load_fixtures!
        puts "loading fixtures from #{config.fixture_file}"
        load config.fixture_file if File.exist?(config.fixture_file)
      end

      def save_fixtures!
        FixtureWriter.new(recorder).save!(config.fixture_file)
      end

      def recorder
        @recorder ||= Recorder.new
      end

      def recorder=(recorder)
        @recorder = recorder
      end
    end
  end
end
