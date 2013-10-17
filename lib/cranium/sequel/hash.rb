require 'sequel'

class Cranium::Sequel::Hash < Hash

  def qualify(options)
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
