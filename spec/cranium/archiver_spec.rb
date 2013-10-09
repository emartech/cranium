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
      Time.stub(:now).and_return Time.new(2000, 1, 1, 1, 2, 3)

      FileUtils.should_receive(:mv).with "gpfdist_home/upload_dir/file.txt", "path/to/archive/2000-01-01_01h02m03s_file.txt"
      FileUtils.should_receive(:mv).with "gpfdist_home/upload_dir/another_file.txt", "path/to/archive/2000-01-01_01h02m03s_another_file.txt"

      Cranium::Archiver.archive "file.txt", "another_file.txt"
    end

  end

end