class Cranium::ImportStrategy::DeleteInsert < Cranium::ImportStrategy::Base

  def import_from(source_table)
    @source_table = source_table

    delete_existing_records
    import_new_records
    database[@source_table].count
  end



  private

  def delete_existing_records
    database.
        from(Sequel.as(target_table, "target"), Sequel.as(@source_table, "source")).
        where(delete_by_fields.qualify keys_with: :source, values_with: :target).
        delete
  end



  def import_new_records
    database[target_table].insert target_fields, database[@source_table].select(*source_fields)
  end



  def delete_by_fields
    Cranium::Sequel::Hash[delete_field_mapping]
  end



  def delete_field_mapping
    import_definition.field_associations.select { |_, target_field| import_definition.delete_insert_on.include? target_field }
  end

end
