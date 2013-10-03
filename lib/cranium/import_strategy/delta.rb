class Cranium::ImportStrategy::Delta < Cranium::ImportStrategy::Base

  def import_from source_table
    database_connection.run insert_query(source_table, import_definition)
  end



  private

  def insert_query(source_table, import_definition)
    <<-sql
      INSERT INTO #{import_definition.to} (#{import_definition.field_associations.values.join ", "})
          SELECT #{import_definition.field_associations.keys.join ", "}
          FROM #{source_table}
    sql
  end

end