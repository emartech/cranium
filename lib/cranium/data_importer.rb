require 'sequel'

class Cranium::DataImporter

  def import(import_definition)
    if import_definition.merge_fields.empty?
      importer = Cranium::ImportStrategy::Delta.new(import_definition)
    else
      importer = Cranium::ImportStrategy::Merge.new(import_definition)
    end
    importer.import
  end



  private

  def database_connection
    @connection ||= Sequel.connect Cranium.configuration.greenplum_connection_string, loggers: Cranium.configuration.loggers
  end



  def insert_query(external_table, import_definition)
    <<-sql
      INSERT INTO #{import_definition.to} (#{import_definition.field_associations.values.join ", "})
          SELECT #{import_definition.field_associations.keys.join ", "}
          FROM #{external_table.name}
    sql
  end



  def merge_update_query(external_table, import_definition)
    <<-sql
      UPDATE #{import_definition.to} AS target SET #{copy_expressions(import_definition)}
      FROM #{external_table.name} AS source WHERE #{join_fields(import_definition)}
    sql
  end



  def merge_insert_query(external_table, import_definition)
    <<-sql
      INSERT INTO #{import_definition.to} (#{import_definition.field_associations.values.join ", "})
          SELECT #{import_definition.field_associations.keys.join ", "}
          FROM #{external_table.name} AS source
              LEFT JOIN #{import_definition.to} AS target
              ON (#{join_fields(import_definition)})
          WHERE
              #{not_in_source? import_definition}
    sql
  end



  def not_in_source?(import_definition)
    import_definition.merge_fields.map { |_, to| "target.#{to} IS NULL" }.join " AND "
  end



  def join_fields import_definition
    import_definition.merge_fields.map { |from, to| "target.#{to} = source.#{from}" }.join " AND "
  end



  def copy_expressions import_definition
    fields_to_set(import_definition).map { |from, to| "#{to} = source.#{from}" }.join ", "
  end



  def fields_to_set(import_definition)
    import_definition.field_associations.reject { |key, _| import_definition.merge_fields.keys.include? key }
  end

end
