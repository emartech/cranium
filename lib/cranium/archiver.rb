require 'fileutils'
require 'time'

module Cranium::Archiver

  def self.archive(*files)
    upload_path = File.join(Cranium.configuration.gpfdist_home_directory, Cranium.configuration.upload_directory)
    archive_path = Cranium.configuration.archive_directory

    create_archive unless File.exists? archive_path

    archive_datetime = Time.now.strftime("%Y-%m-%d_%Hh%Mm%Ss")

    files.each do |file_name|
      FileUtils.mv File.join(upload_path, file_name), File.join(archive_path, "#{archive_datetime}_#{file_name}")
    end
  end



  def self.create_archive
    FileUtils.mkpath Cranium.configuration.archive_directory
  end

end