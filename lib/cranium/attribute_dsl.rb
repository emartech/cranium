module Cranium::AttributeDSL

  def define_attribute(name)
    class_eval <<-attribute_method

      def #{name}(*args)
        return @#{name} if args.count.zero?

        @#{name} = args.first
      end

    attribute_method
  end



  def define_array_attribute(name)
    class_eval <<-attribute_method

      def #{name}(*args)
        return @#{name} || [] if args.count.zero?

        @#{name} = args
      end

    attribute_method
  end

end
