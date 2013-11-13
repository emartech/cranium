require_relative '../spec_helper'

describe Cranium::DimensionManager do
  describe "#insert" do

    context "with single key" do
      let(:manager) { Cranium::DimensionManager.new :table, :source_key }

      it "should store a new record for insertion" do
        manager.insert :target_key, target_key: 123, name: "John"

        manager.rows.should == [{target_key: 123, name: "John"}]
      end

      it "should raise an error if the key field's value isn't specified in the record" do
        expect { manager.insert :target_key, name: "John" }.to raise_error ArgumentError, "Required attribute 'target_key' missing"
      end

      it "should return the key field's value in an array" do
        manager.insert(:target_key, target_key: 123, name: "John").should == 123
      end

      context "if one of the values in the record is a sequence" do
        it "should insert the next value of the specified sequence" do
          sequence = Cranium::Transformation::Sequence.new :id_seq
          sequence.stub next_value: 123

          manager.insert :target_key, target_key: sequence

          manager.rows.should == [{target_key: 123}]
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
