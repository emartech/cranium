require_relative '../spec_helper'

describe Cranium::DataTransformer do

  describe "#transform" do
    it "should raise an error if the target definition's file name has been overriden" do
      source = Cranium::DSL::SourceDefinition.new :source
      target = Cranium::DSL::SourceDefinition.new :target

      target.file "overriden filename"

      expect { Cranium::DataTransformer.new(source, target).transform }.to raise_error StandardError, "Source definition 'target' cannot overrride the file name because it is a transformation target"
    end
  end

end
