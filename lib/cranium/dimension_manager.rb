class Cranium::DimensionManager

  attr_reader :rows



  def self.for(table_name, key_fields)
    @instances ||= {}
    @instances[[table_name, key_fields]] ||= self.new table_name, key_fields
  end



  def initialize(table_name, key_fields)
    @table_name, @key_fields = table_name, key_fields
    @rows = []

    Cranium.application.after_import { flush }
  end



  def insert(target_key, row)
    raise ArgumentError, "Required attribute '#{target_key}' missing" unless row.has_key? target_key

    @rows << resolve_sequence_values(row)
    row[target_key]
  end



  def create_cache_for_field(value_field)
    to_multi_key_cache(db.select_map(@key_fields + [value_field]))
  end



  def flush
    db.multi_insert(@rows, slice: INSERT_BATCH_SIZE) unless @rows.empty?
    @rows = []
  end



  private

  INSERT_BATCH_SIZE = 100_000.freeze



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
