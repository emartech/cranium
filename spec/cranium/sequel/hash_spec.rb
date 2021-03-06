require_relative '../../spec_helper'

describe Cranium::Sequel::Hash do

  let(:source_hash) { { :field1 => :field2, :field3 => :field4 } }
  let(:sequel_hash) { Cranium::Sequel::Hash[source_hash] }

  before(:each) do
    allow(Sequel).to receive(:qualify) { |qualifier, field| :"#{qualifier}_#{field}" }
  end


  it "should be a Hash" do
    expect(Cranium::Sequel::Hash.new).to be_a Hash
  end


  describe "#qualify" do
    context "when called with 'keys_with'" do
      it "should qualify only the key fields of the hash" do
        expect(sequel_hash.qualify(keys_with: :table1)).to eq({ :table1_field1 => :field2, :table1_field3 => :field4 })
      end
    end

    context "when called with 'values_with'" do
      it "should qualify only the value fields of the hash" do
        expect(sequel_hash.qualify(values_with: :table1)).to eq({ :field1 => :table1_field2, :field3 => :table1_field4 })
      end
    end

    context "when called with both 'keys_with' and 'values_with'" do
      it "should qualify both keys and value fields of the hash" do
        expect(sequel_hash.qualify(keys_with: :table1, values_with: :table2)).to eq({ :table1_field1 => :table2_field2, :table1_field3 => :table2_field4 })
      end
    end

    it "should raise an error if called with unsupported options" do
      expect { sequel_hash.qualify key_with: :table }.to raise_error ArgumentError, "Unsupported option for qualify: key_with"
    end
  end


  describe "#qualified_keys" do
    it "should return an array with the hash's keys qualified with the specified qualifier" do
      expect(sequel_hash.qualified_keys(:table)).to eq([:table_field1, :table_field3])
    end
  end


  describe "#qualified_values" do
    it "should return an array with the hash's values qualified with the specified qualifier" do
      expect(sequel_hash.qualified_values(:table)).to eq([:table_field2, :table_field4])
    end
  end

end
