require 'fileutils'

module Cranium::Archiver

  def self.archive(*files)
    upload_path = File.join(Cranium.configuration.gpfdist_home_directory, Cranium.configuration.upload_directory)
    archive_path = Cranium.configuration.archive_directory

    create_archive unless File.exists? archive_path

    files.each do |file_name|
      FileUtils.mv File.join(upload_path, file_name), archive_path
    end
  end



  def self.create_archive
    FileUtils.mkpath Cranium.configuration.archive_directory
  end

end