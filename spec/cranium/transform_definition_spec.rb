require_relative '../spec_helper'

describe Cranium::TransformDefinition do

  let(:transform) { Cranium::TransformDefinition.new :source => :target }

  describe "#source_name" do
    it "should return the name of the source of the transformation" do
      transform.source_name.should == :source
    end
  end


  describe "#target_name" do
    it "should return the name of the target of the transformation" do
      transform.target_name.should == :target
    end
  end
end