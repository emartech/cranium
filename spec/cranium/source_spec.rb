require_relative '../spec_helper'

describe Cranium::Source do

  let(:source) { Cranium::Source.new "name" }

  describe "#file_name" do
    it "should return the the source name as the default filename" do
      source.file_name.should == "name.csv"
    end
  end


  describe "#file" do
    it "should set the file_name" do
      source.file "new_file_name.csv"

      source.file_name.should == "new_file_name.csv"
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


  describe "#==" do
    it "should return true if all attributes of two sources are equal" do
      source1 = Cranium::Source.new "name"
      source1.file "filename"
      source1.field :field, String

      source2 = Cranium::Source.new "name"
      source2.file "filename"
      source2.field :field, String

      source1.should == source2
    end
  end

end
