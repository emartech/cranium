require_relative '../spec_helper'

describe Cranium::TransformationRecord do

  let(:record) { Cranium::TransformationRecord.new [:field1, :field2, :field3], [:field1, :field2, :field3] }

  describe "#input_data=" do
    it "should set the input data row" do
      record.input_data = ["one", "three", "five"]
      expect(record.data).to eq({ :field1 => "one", :field2 => "three", :field3 => "five" })
    end
  end


  describe "#[]" do
    it "should access the fields of the record as if it were a Hash" do
      record.input_data = ["one", "two", "three"]
      expect(record[:field2]).to eq("two")
    end
  end


  describe "#[]=" do
    it "should set the fields of the record as if it were a Hash" do
      record.input_data = ["one", "two", "three"]
      record[:field2] = "four"
      expect(record[:field2]).to eq("four")
    end
  end


  describe "#split_field" do

    let(:record) { Cranium::TransformationRecord.new [:source_field], [:target_field1, :target_field2] }

    it "should store values into respective fields and drop extra values" do
      record.input_data = ["first|second|third"]
      record.split_field :source_field, into: [:target_field1, :target_field2], by: "|"
      expect(record[:target_field1]).to eq("first")
      expect(record[:target_field2]).to eq("second")
    end

    context "when default value is not set" do
      it "should repeat last value when there are not enough values" do
        record.input_data = ["first"]
        record.split_field :source_field, into: [:target_field1, :target_field2], by: "|"
        expect(record[:target_field1]).to eq("first")
        expect(record[:target_field2]).to eq("first")
      end
    end

    context "when default value is specified" do
      it "should use default value when there are not enough values" do
        record.input_data = ["first"]
        record.split_field :source_field, into: [:target_field1, :target_field2], by: "|", default_value: "--"
        expect(record[:target_field1]).to eq("first")
        expect(record[:target_field2]).to eq("--")
      end
    end

  end


  describe "#has_key?" do
    it "should return true if the record contains data for the specified key" do
      record.input_data = ["one", "two", "three"]

      expect(record.has_key?(:field1)).to be_truthy
    end

    it "should return false if the record doesn't contain data for the specified key" do
      record.input_data = ["one", "two", "three"]

      expect(record.has_key?(:field4)).to be_falsey
    end
  end

end
