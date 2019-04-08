module FactoryBot
  module FixtureGenerator
    class FixtureWriter
      attr_reader :recorder

      def initialize(recorder)
        @recorder = recorder
      end

      def save!(fixture_file)
        File.write(fixture_file, recorded_factories)
      end

      def recorded_factories
        recorder.identity_map.flat_map do |k, objects|
          objects.map do |obj|
            "FactoryBot.create(#{recorder.args_map[k].map(&:inspect).join(", ")})"
          end
        end.join("\n")
      end
    end
  end
end
