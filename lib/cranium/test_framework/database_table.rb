class Cranium::TestFramework::DatabaseTable

  def initialize(table_name, db_connection)
    @table_name, @db = table_name, db_connection
  end



  def create(fields)
    @db.run "CREATE TABLE #{@table_name} (#{fields.map { |field| "#{field["field_name"]} #{field["field_type"]}" }.join ", " })"
    self.class.tables_created << self
  end



  def destroy
    @db.run "DROP TABLE #{@table_name}"
  end



  def content(fields = ["*".to_sym])
    @db[@table_name].select(*fields).all
  end



  class << self

    def tables_created
      @tables_created ||= []
    end



    def cleanup
      tables_created.each { |table| table.destroy }
    end

  end

end
