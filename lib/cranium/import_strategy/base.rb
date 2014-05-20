class Cranium::ImportStrategy::Base

  attr_reader :import_definition



  def initialize(import_definition)
    @import_definition = import_definition
  end



  def import
    external_table = Cranium::ExternalTable.new Cranium.application.sources[import_definition.name], Cranium::Database.connection

    external_table.create
    number_of_items_imported = import_from external_table.name
    external_table.destroy

    number_of_items_imported
  end



  protected

  def import_from(external_table)
    raise StandardError "Not implemented"
  end



  def database
    Cranium::Database.connection
  end



  def target_table
    import_definition.into
  end



  def aliased_fields
    import_definition.field_associations.map { |association| "#{association[0]}___#{association[1]}".to_sym }
  end

end
