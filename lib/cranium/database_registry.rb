class Cranium::DatabaseRegistry

  def initialize
    @databases = {}
  end



  def [](name)
    @databases[name]
  end



  def register_database(name, &block)
    database = Cranium::DSL::DatabaseDefinition.new name
    database.instance_eval &block
    @databases[name] = database
  end

end
