class Cranium::ImportStrategy::Delta < Cranium::ImportStrategy::Base

  def import_from(source_table)
    Cranium::Database.connection.run insert_query(source_table, import_definition)
  end



  private

  def insert_query(source_table, import_definition)
    <<-sql
      INSERT INTO #{import_definition.into} (#{import_definition.field_associations.values.map { |field| %Q["#{field}"] }.join ", "})
          SELECT #{import_definition.field_associations.keys.map { |field| %Q["#{field}"] }.join ", "}
          FROM #{source_table}
    sql
  end

end
