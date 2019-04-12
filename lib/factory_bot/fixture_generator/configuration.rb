module FactoryBot
  module FixtureGenerator
    class Configuration
      attr_writer :fixture_file

      def fixture_file
        @fixture_file ||= File.join()
      end
    end
  end
end
