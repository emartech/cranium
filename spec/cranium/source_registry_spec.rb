require_relative '../spec_helper'

describe Cranium::SourceRegistry do

  let(:registry) { Cranium::SourceRegistry.new }

  describe "#[]" do
    it "should raise an error if a source with the specified name wasn't registered yet" do
      expect { registry[:name] }.to raise_error "Undefined source 'name'"
    end
  end


  describe "#register_source" do
    it "should register a new source and configure it through the block passed" do
      source = Cranium::DSL::SourceDefinition.new :test_source
      source.field :test_field, String

      registry.register_source :test_source do
        field :test_field, String
      end

      registry[:test_source].should == source
    end

    it "should return the newly registered source" do
      registry.register_source :test_source do end.should be_a Cranium::DSL::SourceDefinition
    end
  end

end
