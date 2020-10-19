require_relative '../spec_helper'

describe Cranium::DataImporter do
  let(:connection) { double 'a_connection' }

  before do
    allow(Cranium::Database).to receive(:connection).and_return connection
    allow(connection).to receive(:transaction).and_yield
  end

  let(:importer) { Cranium::DataImporter.new }
  let(:definition) { Cranium::DSL::ImportDefinition.new "definition_name" }

  describe "#import" do

    context "when called with delete_on strategy" do
      xit "calls Delete strategy" do
        import_strategy = instance_double Cranium::ImportStrategy::Delete
        allow(Cranium::ImportStrategy::Delete).to receive(:new).with(definition).and_return import_strategy
        expect(import_strategy).to receive(:import).and_return 0
        definition.delete_on :source_id

        importer.import definition
      end
    end

    context "when called with both merge and delete_on fields set" do
      it "should raise an exception" do
        definition.delete_on :source_id
        definition.merge_on :another_field

        expect { importer.import(definition) }.to raise_error StandardError, "Import should not combine merge_on, delete_insert_on, delete_on and truncate_insert settings"
      end
    end

    context "when called with both merge and delete_insert fields set" do
      it "should raise an exception" do
        definition.delete_insert_on :some_field
        definition.merge_on :another_field

        expect { importer.import(definition) }.to raise_error StandardError, "Import should not combine merge_on, delete_insert_on, delete_on and truncate_insert settings"
      end
    end

    context "when called with both merge and truncate_insert fields set" do
      it "should raise an exception" do
        definition.truncate_insert true
        definition.merge_on :another_field

        expect { importer.import(definition) }.to raise_error StandardError, "Import should not combine merge_on, delete_insert_on, delete_on and truncate_insert settings"
      end
    end

    context "when called with both delete_insert and truncate_insert fields set" do
      it "should raise an exception" do
        definition.delete_insert_on :some_field
        definition.truncate_insert true

        expect { importer.import(definition) }.to raise_error StandardError, "Import should not combine merge_on, delete_insert_on, delete_on and truncate_insert settings"
      end
    end

    context "when called with both merge, delete_insert and truncate_insert fields set" do
      it "should raise an exception" do
        definition.delete_insert_on :some_field
        definition.merge_on :another_field
        definition.truncate_insert true

        expect { importer.import(definition) }.to raise_error StandardError, "Import should not combine merge_on, delete_insert_on, delete_on and truncate_insert settings"
      end
    end

  end

end
