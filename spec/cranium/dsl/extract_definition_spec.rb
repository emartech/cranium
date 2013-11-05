require_relative '../../spec_helper'

describe Cranium::DSL::ExtractDefinition do

  let(:extract) { Cranium::DSL::ExtractDefinition.new "name" }


  describe "#name" do
    it "should return the name of the extract definition" do
      extract.name.should == "name"
    end
  end


  describe "#from" do
    it "should set the attribute to the specified value" do
      extract.from :database
      extract.from.should == :database
    end
  end


  describe "#query" do
    it "should set the attribute to the specified value" do
      extract.query "extract query"
      extract.query.should == "extract query"
    end
  end

end
