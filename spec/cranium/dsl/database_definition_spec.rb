require_relative '../../spec_helper'

describe Cranium::DSL::DatabaseDefinition do

  let(:database) { Cranium::DSL::DatabaseDefinition.new "name" }


  describe "#name" do
    it "should return the name of the database definition" do
      database.name.should == "name"
    end
  end


  describe "#connect_to" do
    it "should set the attribute to the specified value" do
      database.connect_to "value"

      database.connect_to.should == "value"
    end
  end

end
