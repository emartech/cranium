class Cranium::TestFramework::DatabaseTable < Cranium::TestFramework::DatabaseEntity


  def create(fields)
    connection.run "CREATE TABLE #{entity_name} (#{fields.map { |field| "#{field[:field_name]} #{field[:field_type]}" }.join ", " })"
    self.class.entities_created << self
  end



  def destroy
    connection.run "DROP TABLE #{entity_name}"
  end



  def content(fields = ["*".to_sym])
    connection[entity_name].select(*fields).all
  end



  def insert(data)
    data.each do |row|
      connection[entity_name].insert row
    end
  end


end