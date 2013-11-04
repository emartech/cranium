require_relative '../spec_helper'

describe Cranium::DataTransformer do

  before(:each) do
    @source = Cranium::DSL::SourceDefinition.new :source
    @target = Cranium::DSL::SourceDefinition.new :target

    Cranium.stub_chain(:application, :sources, :[]).with(:source).and_return(@source)
    Cranium.stub_chain(:application, :sources, :[]).with(:target).and_return(@target)

    @transform_definition = Cranium::DSL::TransformDefinition.new :source => :target
  end


  describe "#transform" do
    it "should raise an error if the target definition's file name has been overriden" do
      @target.file "overriden filename"

      expect do
        Cranium::DataTransformer.new(@transform_definition).transform
      end.to raise_error StandardError, "Source definition 'target' cannot overrride the file name because it is a transformation target"
    end
  end

end
