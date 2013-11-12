class Cranium::TransformationRecord

  attr_reader :data



  def initialize(source_fields, target_fields)
    @source_fields, @target_fields = source_fields, target_fields
  end



  def input_data=(values)
    @data = Hash[@source_fields.zip values]
  end



  def [](field)
    @data[field]
  end



  def []=(field, value)
    @data[field] = value
  end



  def split_field(field, options)
    values = @data[field].split(options[:by])

    options[:into].each_with_index do |target_field, index|
      @data[target_field] = values[index] || options[:default_value] || values.last
    end
  end



  def has_key?(key)
    @data.has_key? key
  end

end
