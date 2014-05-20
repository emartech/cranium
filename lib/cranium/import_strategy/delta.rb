class Cranium::ImportStrategy::Delta < Cranium::ImportStrategy::Base

  def import_from(source_table)
    database[import_definition.into].multi_insert database[source_table].select(*aliased_fields)
    database[source_table].count
  end

end
