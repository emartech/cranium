require_relative '../spec_helper'

describe Cranium::Archiver do

  before(:each) do
    allow(Cranium).to receive_messages(configuration: Cranium::Configuration.new.tap do |config|
      config.gpfdist_home_directory = "gpfdist_home"
      config.upload_directory = "upload_dir"
      config.archive_directory = "path/to/archive"
    end)
  end


  describe ".archive" do
    it "should create the archive directory if it doesn't exist" do
      allow(Dir).to receive(:exists?).with("path/to/archive").and_return(false)

      expect(FileUtils).to receive(:mkpath).with "path/to/archive"

      Cranium::Archiver.archive
    end

    it "should move files to the archive directory" do
      allow(Dir).to receive(:exists?).with("path/to/archive").and_return(true)
      allow(Time).to receive(:now).and_return Time.new(2000, 1, 1, 1, 2, 3)

      expect(FileUtils).to receive(:mv).with "gpfdist_home/upload_dir/file.txt", "path/to/archive/2000-01-01_01h02m03s_file.txt"
      expect(FileUtils).to receive(:mv).with "gpfdist_home/upload_dir/another_file.txt", "path/to/archive/2000-01-01_01h02m03s_another_file.txt"

      Cranium::Archiver.archive "file.txt", "another_file.txt"
    end
  end


  describe ".remove" do
    it "should remove files from the upload directory" do
      expect(FileUtils).to receive(:rm).with "gpfdist_home/upload_dir/file.txt"
      expect(FileUtils).to receive(:rm).with "gpfdist_home/upload_dir/another_file.txt"

      Cranium::Archiver.remove "file.txt", "another_file.txt"
    end
  end

end
