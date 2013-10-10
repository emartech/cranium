require_relative '../spec_helper'

describe Cranium::Archiver do

  before(:each) do
    Cranium.stub(configuration: Cranium::Configuration.new.tap do |config|
      config.gpfdist_home_directory = "gpfdist_home"
      config.upload_directory = "upload_dir"
      config.archive_directory = "path/to/archive"
    end)
  end


  describe ".archive" do
    it "should create the archive directory if it doesn't exist" do
      Dir.stub(:exists?).with("path/to/archive").and_return(false)

      FileUtils.should_receive(:mkpath).with "path/to/archive"

      Cranium::Archiver.archive
    end

    it "should move files to the archive directory" do
      Dir.stub(:exists?).with("path/to/archive").and_return(true)
      Time.stub(:now).and_return Time.new(2000, 1, 1, 1, 2, 3)

      FileUtils.should_receive(:mv).with "gpfdist_home/upload_dir/file.txt", "path/to/archive/2000-01-01_01h02m03s_file.txt"
      FileUtils.should_receive(:mv).with "gpfdist_home/upload_dir/another_file.txt", "path/to/archive/2000-01-01_01h02m03s_another_file.txt"

      Cranium::Archiver.archive "file.txt", "another_file.txt"
    end
  end

end
