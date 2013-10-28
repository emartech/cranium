class Cranium::TestFramework::DatabaseSequence < Cranium::TestFramework::DatabaseEntity


  def create(start_value = 1)
    connection.run "CREATE sequence #{entity_name} START WITH #{start_value}"
    self.class.entities_created << self
  end



  def destroy
    connection.run "DROP SEQUENCE #{entity_name}"
  end


end