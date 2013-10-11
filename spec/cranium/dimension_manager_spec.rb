require_relative '../spec_helper'

describe Cranium::DimensionManager do

  let(:manager) { Cranium::DimensionManager.new :table, :key }

  describe "#insert" do
    it "should store a new record for insertion" do
      manager.insert key: 123, name: "John"

      manager.rows.should == [{ key: 123, name: "John" }]
    end

    it "should raise an error if the key field's value isn't specified in the record" do
      expect { manager.insert name: "John" }.to raise_error ArgumentError, "Required attribute 'key' missing"
    end

    it "should return the key field's value" do
      manager.insert(key: 123, name: "John").should == 123
    end

    context "if one of the values in the record is a sequence" do
      it "should insert the next value of the specified sequence" do
        sequence = Cranium::Transformation::Sequence.new :id_seq
        sequence.stub next_value: 123

        manager.insert key: sequence

        manager.rows.should == [{ key: 123 }]
      end
    end
  end

end
