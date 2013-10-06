require_relative '../spec_helper'

describe Cranium::TransformationRecord do

  let(:record) { Cranium::TransformationRecord.new [:field1, :field2, :field3], [:field1, :field2, :field3] }

  describe "#input_data=" do
    it "should set the input data row" do
      record.input_data = ["one", "three", "five"]
      record.output_data.should == ["one", "three", "five"]
    end
  end


  describe "#output_data" do
    it "should return the data fields specified by the target structure" do
      record = Cranium::TransformationRecord.new [:field1, :field2, :field3], [:field1, :field3]
      record.input_data = ["one", "two", "three"]
      record.output_data.should == ["one", "three"]
    end

    it "should return the data in the order specified by the target structure" do
      record = Cranium::TransformationRecord.new [:field1, :field2], [:field3, :field2]
      record.input_data = ["one", "two"]
      record[:field3] = "three"
      record.output_data.should == ["three", "two"]
    end

    it "should strip whitespaces from the beginning and end of all data values" do
      record.input_data = ["  one", "two  ", "   three   "]
      record.output_data.should == ["one", "two", "three"]
    end
  end


  describe "#[]" do
    it "should access the fields of the record as if it were a Hash" do
      record.input_data = ["one", "two", "three"]
      record[:field2].should == "two"
    end
  end


  describe "#[]=" do
    it "should set the fields of the record as if it were a Hash" do
      record.input_data = ["one", "two", "three"]
      record[:field2] = "four"
      record[:field2].should == "four"
    end
  end


  describe "#split_field" do

    let(:record) { Cranium::TransformationRecord.new [:source_field], [:target_field1, :target_field2] }

    it "should store values into respective fields and drop extra values" do
      record.input_data = ["first|second|third"]
      record.split_field :source_field, into: [:target_field1, :target_field2], by: "|"
      record[:target_field1].should == "first"
      record[:target_field2].should == "second"
    end

    context "when default value is not set" do
      it "should repeat last value when there are not enough values" do
        record.input_data = ["first"]
        record.split_field :source_field, into: [:target_field1, :target_field2], by: "|"
        record[:target_field1].should == "first"
        record[:target_field2].should == "first"
      end
    end

    context "when default value is specified" do
      it "should use default value when there are not enough values" do
        record.input_data = ["first"]
        record.split_field :source_field, into: [:target_field1, :target_field2], by: "|", default_value: "--"
        record[:target_field1].should == "first"
        record[:target_field2].should == "--"
      end
    end

  end

end

