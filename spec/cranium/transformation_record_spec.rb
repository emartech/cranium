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

end
