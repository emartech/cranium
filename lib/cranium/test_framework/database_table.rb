class Cranium::TestFramework::DatabaseTable < Cranium::TestFramework::DatabaseEntity


  def create(fields)
    connection.run "CREATE TABLE #{entity_name} (#{fields.map { |field| "#{field[:field_name]} #{field[:field_type]}" }.join ", " })"
    self.class.entities_created << self
  end



  def destroy
    connection.run "DROP TABLE #{entity_name}"
  end



  def count
    connection[entity_name].count
  end



  def content(fields = ["*".to_sym])
    connection[entity_name].select(*fields).all
  end



  def insert(data)
    connection[entity_name].multi_insert data
  end



  def clear
    connection[entity_name].truncate
  end

end
