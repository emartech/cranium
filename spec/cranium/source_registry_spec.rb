require_relative '../spec_helper'

describe Cranium::SourceRegistry do

  let(:registry) { Cranium::SourceRegistry.new }

  describe "#[]" do
    it "should return nil if a source with the specified name wasn't registered yet" do
      registry[:name].should be_nil
    end
  end


  describe "#register_source" do
    it "should register a new source and configure it through the block passed" do
      source = Cranium::Source.new :test_source
      source.field :test_field, String

      registry.register_source :test_source do
        field :test_field, String
      end

      registry[:test_source].should == source
    end
  end

end
