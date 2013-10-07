class Cranium::TestFramework::CucumberTable

  def self.from_ast_table(ast_table)
    column_types, hashes = process_ast_table ast_table
    new remove_comment_columns(hashes), column_types
  end



  def initialize(array_of_hashes, column_types = {})
    @pattern_replacements, @data, @column_types = {}, array_of_hashes, column_types
  end



  def with_patterns(pattern_replacements)
    self.tap { @pattern_replacements = pattern_replacements }
  end



  def to_step_definition_arg
    dup
  end



  def accept(_)
  end



  def fields
    @data.first.keys
  end



  def data
    column_count = @column_types.count

    evaluate_cells.tap do |array_of_hashes|
      array_of_hashes.define_singleton_method(:columns) do

        result = self.reduce(Hash.new { |hash, key| hash[key] = [] }) do |result, current_hash|
          current_hash.each { |key, value| result[key] << value }
          result
        end.values

        result == [] ? Array.new(column_count) { [] } : result
      end
    end
  end



  def data_array
    data.map { |hash| hash.values.first }
  end



  private

  def evaluate_cells
    @data.map do |row|
      Hash.new.tap do |evaluated_row|

        row.each do |key, value|
          evaluated_value = evaluate_field(key, value)
          evaluated_row[key] = evaluated_value
        end
      end
    end

  end



  def evaluate_field(key, value)
    if @pattern_replacements.keys.include? value
      (@pattern_replacements[value].is_a? Proc) ? @pattern_replacements[value].() : @pattern_replacements[value]
    else
      case @column_types[key]
        when :integer
          value.to_i
        when :numeric
          BigDecimal.new value
        else
          value
      end
    end
  end



  def self.process_ast_table(ast_table)
    column_types = {}
    ast_table = ast_table.map_headers do |header|
      header.match /^(?<name>.*?)(\s+\((?<type>\w{1,2})\))?$/ do |match|
        match[:name].to_sym.tap do |field_name|
          next if comment_field? field_name
          column_types[field_name] = column_type match[:type]
        end
      end
    end

    return column_types, ast_table.hashes
  end



  def self.comment_field?(field_name)
    field_name.to_s.start_with? "#"
  end



  def self.column_type(type_specifier)
    case type_specifier
      when "i"
        :integer
      when "n"
        :numeric
      when "s", nil
        :string
      else
        raise StandardError, "Invalid type specified: #{type_specifier}"
    end
  end



  def self.remove_comment_columns(hashes)
    hashes.map do |hash|
      hash.delete_if { |key| key.to_s.start_with? "#" }
    end
  end

end
