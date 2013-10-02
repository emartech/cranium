require_relative '../spec_helper'

describe Cranium::CSVRecord do
  describe "#data" do
    it "should return the internal data array" do
      record = Cranium::CSVRecord.new
      record.data = ["data item"]
      record.data.should == ["data item"]
    end
  end
end