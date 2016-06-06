module Cranium::FileUtils

  def self.line_count(file_path)
    File.read(file_path).each_line.count
  end

end
