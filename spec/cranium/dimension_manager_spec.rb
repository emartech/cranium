require_relative '../spec_helper'

describe Cranium::DimensionManager do
  describe "#insert" do

    context "with single key" do
      let(:manager) { Cranium::DimensionManager.new :table, [:key] }

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

    context "with multiple keys" do
      let(:manager) { Cranium::DimensionManager.new :table, [:key_1, :key_2] }

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

  describe "#create_cache_for_field" do
    context "with single key" do
      let(:manager) { Cranium::DimensionManager.new :table, [:key] }

      it "should load key-value pairs into a hash" do
        database = double("Database connection")
        manager.stub(:db).and_return database

        database.should_receive(:select_map).with([:key, :value_field]).and_return([ [1, 10], [2, 20] ])

        manager.create_cache_for_field(:value_field).should == { [1] => 10, [2] => 20}
      end
    end

    context "with multiple keys" do
      let(:manager) { Cranium::DimensionManager.new :table, [:key_1, :key_2] }

      it "should load key-value pairs into a hash" do
        database = double("Database connection")
        manager.stub(:db).and_return database

        database.should_receive(:select_map).with([:key_1, :key_2, :value_field]).and_return([ [1, 1, 11], [1, 2, 12], [2, 1, 21] ])

        manager.create_cache_for_field(:value_field).should == { [1, 1] => 11, [1, 2] => 12, [2, 1] => 21}
      end
    end
  end
end
