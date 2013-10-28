class Cranium::TestFramework::DatabaseEntity

  attr_reader :entity_name
  attr_reader :connection



  def initialize(entity, db_connection)
    @entity_name, @connection = entity, db_connection
  end



  class << self

    def entities_created
      @entities_created ||= []
    end



    def cleanup
      entities_created.each { |entity| entity.destroy }
      @entities_created = []
    end

  end

end
