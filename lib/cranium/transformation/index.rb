class Cranium::Transformation::Index

  def initialize
    @indexes = {}
  end



  def lookup(field_name, options)
    validate options

    cache = cache_for(options[:from_table], key_fields(options), field_name)

    if cache.has_key? keys(options)
      cache[keys(options)]
    elsif options.has_key? :if_not_found_then
      options[:if_not_found_then]
    elsif options.has_key? :if_not_found_then_insert
      cache[keys(options)] = Cranium::DimensionManager.for(options[:from_table], field_name).insert(default_value_record(options))
    else
      :not_found
    end
  end



  def validate(options)
    raise ArgumentError, "Cannot specify both :if_not_found_then and :if_not_found_then_insert options" if options.has_key? :if_not_found_then_insert and options.has_key? :if_not_found_then
  end



  private

  def default_value_record(options)
    if options.has_key? :match
      key_values = options[:match]
    else
      key_values = {options[:match_column] => options[:to_value]}
    end
    options[:if_not_found_then_insert].merge(key_values)
  end



  def cache_for(table_name, key_fields, value_field)
    @indexes[[table_name, key_fields, value_field]] ||= Cranium::DimensionManager.for(table_name, key_fields).create_cache_for_field(value_field)
  end



  def key_fields(options)
    if options.has_key? :match
      key_fields = options[:match].keys
    else
      key_fields = [options[:match_column]]
    end
    key_fields
  end



  def keys(options)
    if options.has_key? :match
      keys = options[:match].values
    else
      keys = [options[:to_value]]
    end
    keys
  end

end
