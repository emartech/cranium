class Cranium::Transformation::Index

  def initialize
    @indexes = {}
  end



  def lookup(field_name, options)
    validate options

    cache = cache_for(options[:from_table], options[:match_column], field_name)

    if cache.has_key? options[:to_value]
      cache[options[:to_value]]
    elsif options.has_key? :if_not_found_then
      options[:if_not_found_then]
    elsif options.has_key? :if_not_found_then_insert
      cache[options[:to_value]] = Cranium::DimensionManager.for(options[:from_table], field_name).insert default_value_record(options)
    else
      :not_found
    end
  end



  def validate(options)
    raise ArgumentError, "Cannot specify both :if_not_found_then and :if_not_found_then_insert options" if
      options.has_key? :if_not_found_then_insert and options.has_key? :if_not_found_then
  end



  private

  def default_value_record(options)
    options[:if_not_found_then_insert].merge(options[:match_column] => options[:to_value])
  end



  def cache_for(table_name, key_field, value_field)
    @indexes[[table_name, key_field, value_field]] ||= Cranium::DimensionManager.for(table_name, key_field).create_cache_for_field(value_field)
  end
end
