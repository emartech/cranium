class Cranium::DimensionManager

  attr_reader :rows



  def self.for(table_name, field_name)
    @instances ||= {}
    @instances[[table_name, field_name]] ||= self.new table_name, field_name
  end



  def initialize(table_name, *key_fields)
    @table_name, @key_fields = table_name, key_fields
    @rows = []

    Cranium.application.after_import { flush }
  end



  def insert(row)
    raise ArgumentError, "Required attribute '#{missing_keys(row).join('\', \'')}' missing" unless missing_keys(row).empty?

    @rows << resolve_sequence_values(row)
    @key_fields.map { |key_field| row[key_field] }
  end


  def create_cache_for_field(value_field)
    Hash[db.select_map([@key_fields.first, value_field])]
  end



  def flush
    db.multi_insert(@rows) unless @rows.empty?
    @rows = []
  end



  private

  def missing_keys(row)
    (@key_fields-row.keys)
  end

  def resolve_sequence_values(row)
    row.each do |key, value|
      row[key] = value.next_value if value.is_a? Cranium::Transformation::Sequence
    end
  end



  def db
    Cranium::Database.connection[@table_name]
  end

end
