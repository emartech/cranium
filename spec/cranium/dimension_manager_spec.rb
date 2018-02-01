require_relative '../spec_helper'

describe Cranium::DimensionManager do
  describe "#insert" do

    context "with single key" do
      let(:manager) { Cranium::DimensionManager.new :table, :source_key }

      it "should store a new record for insertion" do
        manager.insert :target_key, target_key: 123, name: "John"

        expect(manager.rows).to eq [{target_key: 123, name: "John"}]
      end

      it "should raise an error if the key field's value isn't specified in the record" do
        expect { manager.insert :target_key, name: "John" }.to raise_error ArgumentError, "Required attribute 'target_key' missing"
      end

      it "should return the key field's value in an array" do
        expect(manager.insert(:target_key, target_key: 123, name: "John")).to eq 123
      end

      context "if one of the values in the record is a sequence" do
        it "should insert the next value of the specified sequence" do
          sequence = Cranium::Transformation::Sequence.new :id_seq
          allow(sequence).to receive(:next_value).and_return(123)

          manager.insert :target_key, target_key: sequence

          expect(manager.rows).to eq [{target_key: 123}]
        end
      end
    end
  end

  describe "#create_cache_for_field" do
    let(:manager) { Cranium::DimensionManager.new :table, keys }

    before do
      database = double("Database connection")
      query = double
      allow(manager).to receive(:db).and_return database
      allow(database).to receive(:select).with(*(keys + [:value_field])).and_return query
      allow(query).to receive(:group).with(*(keys + [:value_field])).and_return dataset
    end

    context "with single key" do
      let(:keys) { [:key] }
      let(:dataset) { [{key: 1, value_field: 10},
                       {key: 2, value_field: 20}] }

      it "should load key-value pairs into a hash" do
        expect(manager.create_cache_for_field(:value_field)).to eq [1] => 10, [2] => 20
      end
    end

    context "with multiple keys" do
      let(:keys) { [:key_1, :key_2] }
      let(:dataset) { [{key_1: 1, key_2: 1, value_field: 11},
                       {key_1: 1, key_2: 2, value_field: 12},
                       {key_1: 2, key_2: 1, value_field: 21}] }

      it "should load key-value pairs into a hash" do
        expect(manager.create_cache_for_field(:value_field)).to eq [1, 1] => 11, [1, 2] => 12, [2, 1] => 21
      end
    end
  end
end
