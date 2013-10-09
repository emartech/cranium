require_relative '../spec_helper'

require 'ostruct'

describe Cranium::Archiver do

  before(:each) do
    Cranium.stub configuration: OpenStruct.new(
        gpfdist_home_directory: "gpfdist_home",
        upload_directory: "upload_dir",
        archive_directory: "path/to/archive"
    )
  end

  describe ".create_archive" do

    it "should create archive directory" do
      FileUtils.should_receive(:mkpath).with "path/to/archive"

      Cranium::Archiver.create_archive
    end

  end


  describe ".archive" do

    it "should move files to the archive directory" do
      FileUtils.should_receive(:mv).with "gpfdist_home/upload_dir/file.txt", "path/to/archive"
      FileUtils.should_receive(:mv).with "gpfdist_home/upload_dir/another_file.txt", "path/to/archive"

      Cranium::Archiver.archive "file.txt", "another_file.txt"
    end

  end

end