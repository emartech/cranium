class File

  def self.line_count(file_path)
    (`wc -l #{file_path}`.match /^\s*(?<line_count>\d+).*/)["line_count"].to_i
  end

end
