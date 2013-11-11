class Cranium::DimensionManager

  attr_reader :rows



  def self.for(table_name, field_name)
    @instances ||= {}
    @instances[[table_name, field_name]] ||= self.new table_name, field_name
  end



  def initialize(table_name, key_fields)
    @table_name, @key_fields = table_name, key_fields
    @rows = []

    Cranium.application.after_import { flush }
  end



  def insert(row)
    raise ArgumentError, "Required attribute '#{@key_fields}' missing" unless row.has_key? @key_fields

    @rows << resolve_sequence_values(row)
    row[@key_fields]
  end



  def create_cache_for_field(value_field)
    to_multi_key_cache(db.select_map(@key_fields + [value_field]))
  end



  def flush
    db.multi_insert(@rows) unless @rows.empty?
    @rows = []
  end



  private

  def to_multi_key_cache(table_data)
    Hash[table_data.map { |row| [row[0..-2], row.last] }]
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
