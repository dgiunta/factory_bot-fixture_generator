module FactoryBot
  module FixtureGenerator
    module FactoryMethods
      attr_accessor :recorder

      def create(factory_name, *args)
        FactoryBot::FixtureGenerator.recorder.record(factory_name, *args) do
          super(factory_name, *args)
        end
      end
    end
  end
end
