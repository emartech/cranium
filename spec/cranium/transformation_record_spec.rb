require_relative '../spec_helper'

describe Cranium::TransformationRecord do

  let(:record) { Cranium::TransformationRecord.new [:field1, :field2, :field3], [:field1, :field2, :field3] }

  describe "#input_data=" do
    it "should set the input data row" do
      record.input_data = ["one", "three", "five"]
      record.data.should == { :field1 => "one", :field2 => "three", :field3 => "five" }
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


  describe "#has_key?" do
    it "should return true if the record contains data for the specified key" do
      record.input_data = ["one", "two", "three"]

      record.has_key?(:field1).should be_truthy
    end

    it "should return false if the record doesn't contain data for the specified key" do
      record.input_data = ["one", "two", "three"]

      record.has_key?(:field4).should be_falsey
    end
  end

end
