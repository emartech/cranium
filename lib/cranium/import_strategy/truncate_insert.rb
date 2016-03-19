class Cranium::ImportStrategy::TruncateInsert < Cranium::ImportStrategy::Base

  def import_from(source_table)
    @source_table = source_table

    database[target_table].truncate
    import_new_records
    database[@source_table].count
  end



  private

  def import_new_records
    database.run database[target_table].insert_sql(target_fields, database[@source_table].select(*source_fields))
  end

end
