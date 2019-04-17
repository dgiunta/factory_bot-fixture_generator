module FactoryBot
  module FixtureGenerator
    class FixtureWriter
      class VarString
        def initialize(str)
          @str = str
        end

        def to_s
          @str
        end

        def inspect
          @str
        end
      end

      attr_reader :recorder

      def initialize(recorder)
        @recorder = recorder
      end

      def save!(fixture_file)
        File.write(fixture_file, recorded_factories)
      end

      def recorded_factories
        recorder.identity_map.flat_map do |factory_key, objects|
          objects.map.with_index do |object, index|
            factory_entry(factory_key, object, index)
          end
        end.join("\n")
      end

      private

      def factory_entry(factory_key, object, index)
        factory, *args = args_map[factory_key]

        args.last&.each do |k, v|
          if v.is_a?(ActiveRecord::Base)
            key, objects = recorder.find_identity_for(v)

            # if we can't find the object in our identity map
            # that must mean we created the object incidentally
            # through some other rmeans. In that case, we should
            # remove the argument from this list.
            if objects.nil?
              args.last.delete(k)
            else
              object_index = objects.index(v)

              args.last[k] = variable_name(key, object_index)
            end
          end
        end

        var_name = variable_name(factory_key, index)
        "#{var_name} = #{config.factory_klass}.create(#{[factory.inspect, *args].compact.join(", ")})"
      end

      def variable_name(key, index)
        factory, *_args = recorder.args_map[key]
        VarString.new("_" + [factory, key, index].join("_"))
      end

      def identity_map
        @identity_map ||= recorder.identity_map.dup
      end

      def args_map
        @args_map ||= recorder.args_map.dup
      end

      def config
        @config ||= FactoryBot::FixtureGenerator.config
      end
    end
  end
end
