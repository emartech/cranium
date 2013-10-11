require_relative '../../spec_helper'
require 'ostruct'

describe Cranium::DSL::SourceDefinition do

  let(:source) { Cranium::DSL::SourceDefinition.new "name" }


  { file: "name.csv",
    delimiter: ",",
    escape: '"',
    quote: '"',
    encoding: "UTF-8" }.each do |attribute, default_value|

    describe "#attribute" do
      context "if called without a parameter" do
        it "should return the (default) value of the attribute" do
          source.send(attribute).should == default_value
        end
      end

      context "if called with a parameter" do
        it "should set the attribute to the specified value" do
          source.send(attribute, "new value")

          source.send(attribute).should == "new value"
        end
      end
    end

  end


  describe "#fields" do
    it "should return an empty Hash if no fields are set" do
      source.fields.should == {}
    end

    it "should return the fields and types that were set" do
      source.field :field1, String
      source.field :field2, Fixnum

      source.fields.should == {
        field1: String,
        field2: Fixnum
      }
    end
  end


  describe "#file_name_overriden?" do
    it "should signal if the file name parameter of the source definition has been set to something other than the default" do
      source.file_name_overriden?.should be_false

      source.file "overriden.csv"
      source.file_name_overriden?.should be_true
    end
  end


  describe "#files" do
    it "should return nil by default" do
      source.files.should be_nil
    end
  end


  describe "#resolve_files" do
    it "should store the file names of all files matching the file pattern" do
      Cranium.stub configuration: (Cranium::Configuration.new.tap do |config|
        config.gpfdist_home_directory = "/home/gpfdist"
        config.upload_directory = "customer"
      end)
      source.file "product*.csv"
      Dir.stub(:[]).with("/home/gpfdist/customer/product*.csv").and_return(["/home/gpfdist/customer/product2.csv",
                                                                            "/home/gpfdist/customer/product1.csv"])

      source.resolve_files

      source.files.should == ["product1.csv", "product2.csv"]
    end
  end

end
