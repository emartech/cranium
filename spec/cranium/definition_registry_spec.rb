require_relative '../spec_helper'

describe Cranium::DefinitionRegistry do

  let(:registry) { Cranium::DefinitionRegistry.new Cranium::DSL::DatabaseDefinition }

  describe "#[]" do
    it "should return nil if a definition with the specified name wasn't registered yet" do
      expect(registry[:name]).to be_nil
    end
  end


  describe "#register_definition" do
    it "should return the newly registered source" do
      expect(registry.register_definition(:test_database) {}).to be_a Cranium::DSL::DatabaseDefinition
    end

    it "should register a new database definition and configure it through the block passed" do
      expected_definition = Cranium::DSL::DatabaseDefinition.new :test_database
      expected_definition.connect_to "connection string"

      registry.register_definition :test_database do
        connect_to "connection string"
      end

      expect(registry[:test_database]).to eq expected_definition
    end


    it "should register a new source definition and configure it through the block passed" do
      registry = Cranium::DefinitionRegistry.new Cranium::DSL::SourceDefinition
      expected_definition = Cranium::DSL::SourceDefinition.new :test_source
      expected_definition.file "test.csv"

      registry.register_definition :test_source do
        file "test.csv"
      end

      expect(registry[:test_source]).to eq expected_definition
    end

  end

end
