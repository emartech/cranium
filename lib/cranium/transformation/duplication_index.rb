class Cranium::Transformation::DuplicationIndex

  def self.[](*fields)
    raise ArgumentError, "Cannot build duplication index for empty fieldset" if fields.empty?
    @instances ||= {}
    @instances[fields] ||= new(*fields)
  end



  def initialize(*fields)
    @fields = fields
    @fingerprints = Set.new
  end



  def duplicate?(record)
    fingerprint = take_fingerprint(record)

    if @fingerprints.include? fingerprint
      true
    else
      @fingerprints.add fingerprint
      false
    end
  end



  private

  def take_fingerprint(record)
    @fields.map do |field_name|
      raise StandardError, "Missing deduplication key from record: #{field_name}" unless record.has_key? field_name
      record[field_name]
    end
  end

end
