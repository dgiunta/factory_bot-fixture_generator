module FactoryBot
  module FixtureGenerator
    class Configuration
      attr_writer :fixture_file, :factory_klass

      def fixture_file
        @fixture_file ||= File.join()
      end

      def factory_klass
        @factory_klass ||= FactoryBot
      end
    end
  end
end
