class Cranium::DataImporter

  def initialize(name)
    @name = name
    @field_associations = {}
    @merge_fields = []
  end



  def to(table)
    @table = table
  end



  def put(field_associations)
    @field_associations.merge! field_associations
  end



  def merge_on(*fields)
    @merge_fields.concat fields
  end



  def import
    p self
  end

end
