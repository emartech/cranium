class Cranium::ImportStrategy::Base

  attr_reader :import_definition



  def initialize(import_definition)
    @import_definition = import_definition
  end



  def import
    external_table = Cranium::ExternalTable.new Cranium.application.sources[import_definition.name], database_connection
    external_table.create

    begin
      import_from external_table.name
    ensure
      external_table.destroy
    end
  end



  def import_from(external_table)
    raise StandardError "Not implemented"
  end



  def database_connection
    @connection ||= Sequel.connect Cranium.configuration.greenplum_connection_string, loggers: Cranium.configuration.loggers
  end

end