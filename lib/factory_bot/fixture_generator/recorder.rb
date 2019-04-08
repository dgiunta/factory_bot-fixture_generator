module FactoryBot
  module FixtureGenerator
    class Recorder
      def reset_counts!
        @counts = nil
      end

      def record(factory_name, *args, &block)
        return block.call unless recordable?(factory_name)

        key = key_for(factory_name, *args)
        count = counts[key] += 1

        save_to_args_map(key, factory_name, args)
        find_or_create_in_identity_map(key, count-1, &block)
      end

      def key_for(*args)
        Digest::MD5.new.hexdigest(args.compact.inspect)
      end

      def count_for(factory_name, *args)
        counts[key_for(factory_name, *args)]
      end

      def identities_for(factory_name, *args)
        identity_map[key_for(factory_name, *args)]
      end

      def identity_map
        @identity_map ||= {}
      end

      def args_map
        @args_map ||= {}
      end

      private

      def counts
        @counts ||= Hash.new(0)
      end

      def save_to_args_map(key, factory_name, args)
        args_map[key] ||= [factory_name, *args]
      end

      def find_or_create_in_identity_map(key, index, &block)
        identity_map[key] ||= []
        if object = identity_map[key][index].presence
          object.reload
        else
          identity_map[key][index] = block.call
        end
      end

      def recordable?(factory_name)
        klass = FactoryBot.factories[factory_name].build_class

        klass.respond_to?(:descends_from_active_record?) && klass.descends_from_active_record?
      end
    end
  end
end
