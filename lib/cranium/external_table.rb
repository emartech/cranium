class Cranium::ExternalTable

  def initialize(source, db_connection, error_threshold: nil)
    @source = source
    @connection = db_connection
    @error_threshold = error_threshold
  end

  def create
    @connection.run external_table_sql
  end

  def destroy
    @connection.run %Q[DROP EXTERNAL TABLE "#{name}"]
  end

  def name
    :"external_#{@source.name}"
  end

  private

  def external_table_sql
    external_table_sql = <<~sql
      CREATE EXTERNAL TABLE "#{name}" (
          #{field_definitions}
      )
      LOCATION (#{external_location})
      FORMAT 'CSV' (DELIMITER '#{quote @source.delimiter}' ESCAPE '#{quote @source.escape}' QUOTE '#{quote @source.quote}' HEADER)
      ENCODING 'UTF8'
    sql

    external_table_sql << "SEGMENT REJECT LIMIT #{@error_threshold} PERCENT\n" unless @error_threshold.nil?
    external_table_sql
  end

  def field_definitions
    @source.fields.map do |name, type|
      %Q("#{name}" #{sql_type_for_ruby_type(type)})
    end.join ",\n    "
  end

  def sql_type_for_ruby_type(type)
    case type.to_s
      when "Integer" then
        "INTEGER"
      when "Float" then
        "NUMERIC"
      when "Date" then
        "DATE"
      when "Time" then
        "TIMESTAMP WITHOUT TIME ZONE"
      when "TrueClass", "FalseClass" then
        "BOOLEAN"
      else
        "TEXT"
    end
  end

  def quote(text)
    text.gsub "'", "''"
  end

  def external_location
    @source.files.map do |file_name|
      "'gpfdist://#{Cranium.configuration.gpfdist_url}/#{Cranium.configuration.upload_directory}/#{file_name}'"
    end.join(', ')
  end

end
