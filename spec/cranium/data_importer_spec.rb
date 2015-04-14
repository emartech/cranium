require_relative '../spec_helper'

describe Cranium::DataImporter do

  let(:importer) { Cranium::DataImporter.new }

  describe "#import" do

    context "when called with both merge and delete_insert fields set" do
      it "should raise an exception" do
        connection = double
        allow(Cranium::Database).to receive(:connection).and_return connection
        expect(connection).to receive(:transaction).and_yield

        definition = Cranium::DSL::ImportDefinition.new "definition_name"
        definition.delete_insert_on :some_field
        definition.merge_on :another_field

        expect { importer.import(definition) }.to raise_error StandardError, "Import should not contain both merge_on and delete_insert_on settings"
      end
    end

  end

end
