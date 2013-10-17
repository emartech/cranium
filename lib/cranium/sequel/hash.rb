require 'sequel'

class Cranium::Sequel::Hash < Hash

  def qualify(options)
    invalid_options = options.keys - [:keys_with, :values_with]
    raise ArgumentError, "Unsupported option for qualify: #{invalid_options.first}" unless invalid_options.empty?
    Hash[qualify_fields(options[:keys_with], keys).zip qualify_fields(options[:values_with], values)]
  end



  def qualified_keys(qualifier)
    qualify_fields qualifier, keys
  end



  def qualified_values(qualifier)
    qualify_fields qualifier, values
  end



  private

  def qualify_fields(qualifier, fields)
    return fields if qualifier.nil?
    fields.map { |field| Sequel.qualify qualifier, field }
  end

end
