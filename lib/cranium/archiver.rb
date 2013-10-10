require 'fileutils'

module Cranium::Archiver

  def self.archive(*files)
    create_archive_directory
    archive_files files
  end



  private

  def self.create_archive_directory
    FileUtils.mkpath Cranium.configuration.archive_directory unless Dir.exists? Cranium.configuration.archive_directory
  end



  def self.archive_files(files)
    archive_datetime = Time.now.strftime("%Y-%m-%d_%Hh%Mm%Ss")
    files.each do |file_name|
      FileUtils.mv File.join(Cranium.configuration.upload_path, file_name),
                   File.join(Cranium.configuration.archive_directory, "#{archive_datetime}_#{file_name}")
    end
  end

end
