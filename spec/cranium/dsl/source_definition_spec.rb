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
          expect(source.send(attribute)).to eq(default_value)
        end
      end

      context "if called with a parameter" do
        it "should set the attribute to the specified value" do
          source.send(attribute, "new value")

          expect(source.send(attribute)).to eq("new value")
        end
      end
    end

  end


  describe "#fields" do
    it "should return an empty Hash if no fields are set" do
      expect(source.fields).to eq({})
    end

    it "should return the fields and types that were set" do
      source.field :field1, String
      source.field :field2, Fixnum

      expect(source.fields).to eq({
        field1: String,
        field2: Fixnum
      })
    end
  end


  describe "#file_name_overriden?" do
    it "should signal if the file name parameter of the source definition has been set to something other than the default" do
      expect(source.file_name_overriden?).to be_falsey

      source.file "overriden.csv"
      expect(source.file_name_overriden?).to be_truthy
    end
  end


  describe "#files" do
    it "should return nil by default" do
      expect(source.files).to be_nil
    end
  end


  describe "#resolve_files" do
    it "should store the file names of all files matching the file pattern" do
      allow(Cranium).to receive_messages configuration: (Cranium::Configuration.new.tap do |config|
        config.gpfdist_home_directory = "/home/gpfdist"
        config.upload_directory = "customer"
      end)
      source.file "product*.csv"
      allow(Dir).to receive(:[]).with("/home/gpfdist/customer/product*.csv").and_return(["/home/gpfdist/customer/product2.csv",
                                                                            "/home/gpfdist/customer/product1.csv"])

      source.resolve_files

      expect(source.files).to eq(["product1.csv", "product2.csv"])
    end
  end

end
