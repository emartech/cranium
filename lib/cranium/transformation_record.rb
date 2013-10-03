class Cranium::TransformationRecord

  def initialize(source_fields, target_fields)
    @source_fields, @target_fields = source_fields, target_fields
  end



  def input_data=(values)
    @data = Hash[@source_fields.zip values]
  end



  def output_data
    @data.keep_if { |key, _| @target_fields.include? key }.values
  end



  def [](field)
    @data[field]
  end



  def []=(field, value)
    @data[field] = value
  end

end
