class Cranium::ImportStrategy::Merge < Cranium::ImportStrategy::Base

  def import_from(source_table)
    @source_table = source_table

    update_existing_records
    import_new_records
    database[@source_table].count
  end



  private

  def update_existing_records
    database.
      from(Sequel.as(target_table, "target"), Sequel.as(@source_table, "source")).
      where(merge_fields.qualify keys_with: :source, values_with: :target).
      update(not_merge_fields.qualify(keys_with: :source).invert)
  end



  def import_new_records
    database.run database[target_table].insert_sql(target_fields,
                                                   database[@source_table].
                                                     left_outer_join(target_table, merge_fields.invert).
                                                     where(merge_fields_are_empty).
                                                     select(*source_fields).qualify)
  end



  def merge_fields
    Cranium::Sequel::Hash[import_definition.merge_fields]
  end



  def not_merge_fields
    Cranium::Sequel::Hash[import_definition.field_associations.reject { |key, _| merge_fields.keys.include? key }]
  end



  def merge_fields_are_empty
    Hash[merge_fields.qualified_values(target_table).zip Array.new(merge_fields.count, nil)]
  end

end
