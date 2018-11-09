require 'fileutils'

module Cranium::Archiver
  class << self
    def archive(*files)
      create_directory(Cranium.configuration.archive_directory)
      archive_datetime = Time.now.strftime("%Y-%m-%d_%Hh%Mm%Ss")
      move_files_from_upload_directory(files, Cranium.configuration.archive_directory, prefix: "#{archive_datetime}_")
    end

    def remove(*files)
      files.each do |file_name|
        FileUtils.rm File.join(Cranium.configuration.upload_path, file_name)
      end
    end

    def move(*files, target_directory:)
      create_directory(target_directory)
      move_files_from_upload_directory(files, target_directory)
    end

    private

    def create_directory(path)
      FileUtils.mkdir_p(path)
    end

    def move_files_from_upload_directory(files, target_directory, prefix: "")
      files.each do |file_name|
        FileUtils.mv(
          File.join(Cranium.configuration.upload_path, file_name),
          File.join(target_directory, "#{prefix}#{file_name}")
        )
      end
    end
  end
end
