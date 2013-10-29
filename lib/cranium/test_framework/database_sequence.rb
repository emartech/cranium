class Cranium::TestFramework::DatabaseSequence < Cranium::TestFramework::DatabaseEntity


  def create
    connection.run "CREATE sequence #{entity_name}"
    self.class.entities_created << self
  end



  def destroy
    connection.run "DROP SEQUENCE #{entity_name}"
  end


end