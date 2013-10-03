class Cranium::ImportStrategy::Merge < Cranium::ImportStrategy::Base

  def import_from source_table
    database_connection.run merge_update_query(source_table)
    database_connection.run merge_insert_query(source_table)
  end



  private

  def merge_update_query(source_table)
    <<-sql
      UPDATE #{import_definition.to} AS target
      SET #{setters}
      FROM #{source_table} AS source
      WHERE #{join_fields}
    sql
  end



  def merge_insert_query(source_table)
    <<-sql
      INSERT INTO #{import_definition.to} (#{target_field_list})
          SELECT #{source_field_list}
          FROM #{source_table} AS source
              LEFT JOIN #{import_definition.to} AS target
              ON (#{join_fields})
          WHERE #{not_in_target?}
    sql
  end



  def source_field_list
    import_definition.field_associations.keys.join ", "
  end



  def target_field_list
    import_definition.field_associations.values.join ", "
  end



  def not_in_target?
    import_definition.merge_fields.map { |_, to| "target.#{to} IS NULL" }.join " AND "
  end



  def join_fields
    import_definition.merge_fields.map { |from, to| "target.#{to} = source.#{from}" }.join " AND "
  end



  def setters
    fields_to_set.map { |from, to| "#{to} = source.#{from}" }.join ", "
  end



  def fields_to_set
    import_definition.field_associations.reject { |key, _| import_definition.merge_fields.keys.include? key }
  end

end