require_relative '../../spec_helper'

describe Cranium::Transformation::DuplicationIndex do

  let(:index) { Cranium::Transformation::DuplicationIndex.new :field1, :field2 }
  let(:record) { Cranium::TransformationRecord.new [:field1, :field2, :field3], [:field1, :field2, :field3] }

  describe ".[]" do
    before(:each) { Cranium::Transformation::DuplicationIndex.instance_variable_set :@instances, nil }

    it "should return a DuplicationIndex instance for the specified fields" do
      allow(Cranium::Transformation::DuplicationIndex).to receive(:new).with(:field1, :field2).and_return(index)

      expect(Cranium::Transformation::DuplicationIndex[:field1, :field2]).to eq index
    end

    it "should memoize the previously created instances" do
      expect(Cranium::Transformation::DuplicationIndex[:field1, :field2]).to eq(Cranium::Transformation::DuplicationIndex[:field1, :field2])
    end

    it "should raise an error if empty fieldset was passed" do
      expect { Cranium::Transformation::DuplicationIndex[] }.to raise_error ArgumentError, "Cannot build duplication index for empty fieldset"
    end
  end


  describe "#duplicate?" do
    it "should return false for the first entry" do
      record.input_data = ["one", "two", "three"]
      expect(index.duplicate?(record)).to be_falsey
    end

    it "should return true the second time it's called for the same record" do
      record.input_data = ["one", "two", "three"]
      index.duplicate?(record)
      expect(index.duplicate?(record)).to be_truthy
    end

    it "should only use the specified fieldset for duplication detection" do
      record1 = record
      record2 = record.clone
      index = Cranium::Transformation::DuplicationIndex.new :field1

      record1.input_data = ["one", "two", "three"]
      index.duplicate? record1

      record2.input_data = ["one", "four", "five"]
      expect(index.duplicate?(record2)).to be_truthy
    end

    it "should handle multiple fields for detection" do
      record1 = record
      record2 = record.clone
      record3 = record.clone
      index = Cranium::Transformation::DuplicationIndex.new :field1, :field2

      record1.input_data = ["one", "two", "three"]
      index.duplicate? record1

      record2.input_data = ["one", "four", "five"]
      expect(index.duplicate?(record2)).to be_falsey

      record3.input_data = ["one", "two", "five"]
      expect(index.duplicate?(record3)).to be_truthy
    end

    it "should raise an error if record fieldset doesn't contain index fieldset" do
      record.input_data = ["one", "two", "three"]
      index = Cranium::Transformation::DuplicationIndex.new :field5

      expect { index.duplicate? record }.to raise_error StandardError, "Missing deduplication key from record: field5"
    end
  end

end
