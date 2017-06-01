require_relative '../spec_helper'

describe Cranium::Configuration do

  let(:config) { Cranium::Configuration.new }

  describe '#log_queries' do
    it { is_expected.to be_truthy }
  end

  describe "#upload_path" do
    it "should return the full upload path" do
      config.gpfdist_home_directory = "/gpfdist/home/dir"
      config.upload_directory = "uploads/customer"

      expect(config.upload_path).to eq "/gpfdist/home/dir/uploads/customer"
    end
  end


  describe "#storage_directory" do
    it "should return the previously set value" do
      config.storage_directory = "/some/path"
      expect(config.storage_directory).to eq "/some/path"
    end

    it "should return the default storage directory if one wasn't explicitly set" do
      config.gpfdist_home_directory = "/gpfdist/home/dir"
      config.upload_directory = "uploads/customer"

      expect(config.storage_directory).to eq "/gpfdist/home/dir/uploads/customer/.cranium"
    end
  end

end
