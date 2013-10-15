class Cranium::ImportStrategy::Delta < Cranium::ImportStrategy::Base

  def import_from(source_table)
    database[import_definition.into].insert target_fields, database[source_table].select(*source_fields)
    database[source_table].count
  end

end
