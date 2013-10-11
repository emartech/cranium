class Cranium::Transformation::Index

  def initialize
    @indexes = {}
  end



  def lookup(field_name, settings)
    cache = cache_for(settings[:from_table], settings[:match_column], field_name)

    if cache.has_key? settings[:to_value]
      cache[settings[:to_value]]
    elsif settings.has_key? :if_not_found_then_insert
      key = Cranium::DimensionManager.for(settings[:from_table], field_name).insert default_value_record(settings)
      cache[settings[:to_value]] = key
    else
      :not_found
    end
  end



  private

  def default_value_record(settings)
    settings[:if_not_found_then_insert].merge(settings[:match_column] => settings[:to_value])
  end



  def cache_for(table_name, key_field, value_field)
    @indexes[[table_name, key_field, value_field]] ||= Cranium::DimensionManager.for(table_name, key_field).create_cache_for_field(value_field)
  end
end
