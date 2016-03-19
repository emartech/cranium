require_relative '../spec_helper'

describe Cranium::DataImporter do

  before do
    connection = double
    allow(Cranium::Database).to receive(:connection).and_return connection
    allow(connection).to receive(:transaction).and_yield
  end

  let(:importer) { Cranium::DataImporter.new }
  let(:definition) { Cranium::DSL::ImportDefinition.new "definition_name" }

  describe "#import" do

    context "when called with both merge and delete_insert fields set" do
      it "should raise an exception" do
        definition.delete_insert_on :some_field
        definition.merge_on :another_field

        expect { importer.import(definition) }.to raise_error StandardError, "Import should not combine merge_on, delete_insert_on and truncate_insert settings"
      end
    end

    context "when called with both merge and truncate_insert fields set" do
      it "should raise an exception" do
        definition.truncate_insert true
        definition.merge_on :another_field

        expect { importer.import(definition) }.to raise_error StandardError, "Import should not combine merge_on, delete_insert_on and truncate_insert settings"
      end
    end

    context "when called with both delete_insert and truncate_insert fields set" do
      it "should raise an exception" do
        definition.delete_insert_on :some_field
        definition.truncate_insert true

        expect { importer.import(definition) }.to raise_error StandardError, "Import should not combine merge_on, delete_insert_on and truncate_insert settings"
      end
    end

    context "when called with both merge, delete_insert and truncate_insert fields set" do
      it "should raise an exception" do
        definition.delete_insert_on :some_field
        definition.merge_on :another_field
        definition.truncate_insert true

        expect { importer.import(definition) }.to raise_error StandardError, "Import should not combine merge_on, delete_insert_on and truncate_insert settings"
      end
    end

  end

end
