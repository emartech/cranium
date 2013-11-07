class Cranium::Extract::DataExtractor

  def execute(extract_definition)
    if extract_definition.incrementally_by.nil?
      Cranium::Extract::Strategy::Simple.new.execute extract_definition
    else
      Cranium::Extract::Strategy::Incremental.new.execute extract_definition
    end
  end

end
