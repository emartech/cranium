class Cranium::DimensionManager

  def self.for(table_name, field_name)
    @instances ||= {}
    @instances[[table_name, field_name]] ||= self.new table_name, field_name
  end



  def initialize(table_name, field_name)
    @table_name, @field_name = table_name, field_name

    @rows = []
    @current_key = nil

    Cranium.application.after_import do
      flush
    end
  end



  def insert(default_values)
    key = next_key
    @rows << default_values.merge(@field_name => key)

    key
  end



  def create_cache_for_field(value_field)
    Hash[Cranium::Database.connection[@table_name].select_map([@field_name, value_field])]
  end



  def flush
    Cranium::Database.connection[@table_name].multi_insert(@rows) unless @rows.empty?
    Cranium::Database.connection["SELECT setval('#{@table_name}_#{@field_name}_seq', #{@current_key}) AS key"]
    @rows = []
  end



  private


  def next_key
    if @current_key.nil?
      @current_key = Cranium::Database.connection["SELECT nextval('#{@table_name}_#{@field_name}_seq') AS key"].first[:key]
    else
      @current_key += 1
    end
  end
end