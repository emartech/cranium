class Cranium::ImportStrategy::Base

  attr_reader :import_definition



  def initialize(import_definition)
    @import_definition = import_definition
  end



  def import
    external_table = Cranium::ExternalTable.new Cranium.application.sources[import_definition.name], Cranium::Database.connection

    external_table.create
    import_from external_table.name
    external_table.destroy
  end



  def import_from(external_table)
    raise StandardError "Not implemented"
  end

end
