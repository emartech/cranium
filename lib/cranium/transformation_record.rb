class Cranium::TransformationRecord

  def initialize(source_fields, target_fields)
    @source_fields, @target_fields = source_fields, target_fields
  end



  def input_data=(values)
    @data = Hash[@source_fields.zip values]
  end



  def output_data
    @data.keep_if { |key| @target_fields.include? key }.sort_by { |field, _| @target_fields.index(field) }.map { |item| item[1] }
  end



  def [](field)
    @data[field]
  end



  def []=(field, value)
    @data[field] = value
  end


  def split_field(field, options)
    values = @data[field]
      .split(options[:by])
      .map { |value| value.strip }

    options[:into].each_with_index do |target_field, index|
      @data[target_field] = values[index] || options[:default_value] || values.last
    end
  end
end
