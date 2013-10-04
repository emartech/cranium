class Cranium::Transformation::Index

  def initialize
    @indexes = {}
  end



  def lookup(field_name, settings)
    cache_for(settings[:from_table], settings[:match_column], field_name)[settings[:to_value]]
  end



  private

  def cache_for(table_name, key_field, value_field)
    @indexes[[table_name, key_field, value_field]] ||= Hash[Cranium::Database.connection[table_name].select_map([key_field, value_field])]
  end

end
