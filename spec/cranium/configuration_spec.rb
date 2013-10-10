require_relative '../spec_helper'

describe Cranium::Configuration do

  let(:config) { Cranium::Configuration.new }

  describe "#upload_path" do
    it "should return the full upload path" do
      config.gpfdist_home_directory = "/gpfdist/home/dir"
      config.upload_directory = "uploads/customer"

      config.upload_path.should == "/gpfdist/home/dir/uploads/customer"
    end
  end

end
