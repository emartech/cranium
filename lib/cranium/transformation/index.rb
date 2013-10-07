class Cranium::Transformation::Index

  def initialize
    @indexes = {}
  end



  def lookup(field_name, settings)
    key = cache_for(settings[:from_table], settings[:match_column], field_name)[settings[:to_value]]

    if key.nil?
      key = next_key(settings[:from_table], field_name)
      Cranium::Database.connection[settings[:from_table]].multi_insert [{field_name.to_sym => key}.merge(settings[:if_missing_insert])]
      cache_for(settings[:from_table], settings[:match_column], field_name)[settings[:to_value]] = key
    end

    key
  end



  private

  def cache_for(table_name, key_field, value_field)
    @indexes[[table_name, key_field, value_field]] ||= Hash[Cranium::Database.connection[table_name].select_map([key_field, value_field])]
  end



  def next_key(table, key_field)
    Cranium::Database.connection["SELECT nextval('#{table}_#{key_field}_seq') AS key"].first[:key]
  end

end
