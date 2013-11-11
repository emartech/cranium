require_relative '../spec_helper'

describe Cranium::DimensionManager do
  describe "#insert" do

    context "single key" do
      let(:manager) { Cranium::DimensionManager.new :table, :key }

      it "should store a new record for insertion" do
        manager.insert key: 123, name: "John"

        manager.rows.should == [{key: 123, name: "John"}]
      end

      it "should raise an error if the key field's value isn't specified in the record" do
        expect { manager.insert name: "John" }.to raise_error ArgumentError, "Required attribute 'key' missing"
      end

      it "should return the key field's value in an array" do
        manager.insert(key: 123, name: "John").should == [123]
      end

      context "if one of the values in the record is a sequence" do
        it "should insert the next value of the specified sequence" do
          sequence = Cranium::Transformation::Sequence.new :id_seq
          sequence.stub next_value: 123

          manager.insert key: sequence

          manager.rows.should == [{key: 123}]
        end
      end
    end

    context "multiple keys" do
      let(:manager) { Cranium::DimensionManager.new :table, :key_1, :key_2 }

      it "should store a new record for insertion" do
        manager.insert key_1: 12, key_2: 34, name: "Joe"

        manager.rows.should == [{key_1: 12, key_2: 34, name: "Joe"}]
      end

      it "should raise an error if any of the key field's velue isn't specified in the record" do
        expect { manager.insert key_1: 1, name: "John" }.to raise_error ArgumentError, "Required attribute 'key_2' missing"
        expect { manager.insert key_2: 1, name: "John" }.to raise_error ArgumentError, "Required attribute 'key_1' missing"
        expect { manager.insert name: "John" }.to raise_error ArgumentError, "Required attribute 'key_1', 'key_2' missing"
      end

      it "should return the key field's values in an array" do
        manager.insert(key_1: 12, key_2:34, name: "John").should == [12, 34]
      end

      context "if one of the values in the record is a sequence" do
        it "should insert the next value of the specified sequence" do
          sequence = Cranium::Transformation::Sequence.new :id_seq
          sequence.stub next_value: 123

          manager.insert key_1: 456, key_2: sequence

          manager.rows.should == [{key_1: 456, key_2: 123 }]
        end
      end
    end
  end
end
