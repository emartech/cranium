class Cranium::Source

  attr_reader :name
  attr_reader :file_name
  attr_reader :fields



  def initialize(name)
    @name = name
    @file_name = "#{name}.csv"
    @fields = {}
  end



  def file(file_name)
    @file_name = file_name
  end



  def field(name, type)
    @fields[name] = type
  end

end