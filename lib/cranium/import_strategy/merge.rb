class Cranium::ImportStrategy::Merge < Cranium::ImportStrategy::Base

  def import_from(source_table)
    database[import_definition.into].
      from(Sequel.as(import_definition.into, "target"), Sequel.as(source_table, "source")).
      where(qualify_fields(import_definition.merge_fields, :source, :target)).
      update(qualify_fields(not_merge_fields.invert, nil, :source))

    database[import_definition.into].insert target_fields,
                                            database[source_table].
                                              left_outer_join(import_definition.into, import_definition.merge_fields.invert).
                                              where(merge_fields_are_empty).
                                              select(*source_fields).qualify
    database[source_table].count
  end



  private

  def qualify_fields(fields_hash, key_qualifier, value_qualifier)
    Hash[
      fields_hash.map do |key_field, value_field|
        [key_qualifier.nil? ? key_field : Sequel.qualify(key_qualifier, key_field),
         value_qualifier.nil? ? value_field : Sequel.qualify(value_qualifier, value_field)]
      end
    ]
  end



  def not_merge_fields
    import_definition.field_associations.reject { |key, _| import_definition.merge_fields.keys.include? key }
  end



  def merge_fields_are_empty
    Hash[import_definition.merge_fields.values.map { |field| [Sequel.qualify(import_definition.into, field), nil] }]
  end

end
