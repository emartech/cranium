class Cranium::ImportStrategy::Base

  attr_reader :import_definition



  def initialize(import_definition)
    @import_definition = import_definition
  end



  def import
    external_table = Cranium::ExternalTable.new Cranium.application.sources[import_definition.name], Cranium::Database.connection
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

end