class Cranium::Transformation::AmendDimension

  def initialize(index)
    @index = index
  end



  def lookup(field_name, settings)
    key = @index.lookup field_name, settings

    if key.nil?
      key = next_key(settings[:from_table], field_name)
      Cranium::Database.connection[settings[:from_table]].multi_insert [{field_name.to_sym => key}.merge(settings[:if_missing_insert])]
      @index.invalidate_cache(settings[:from_table], settings[:match_column], field_name)
    end

    key
  end



  private

  def next_key(table, key_field)
    Cranium::Database.connection["SELECT nextval('#{table}_#{key_field}_seq') AS key"].first[:key]
  end
end