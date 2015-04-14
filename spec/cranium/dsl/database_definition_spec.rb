require_relative '../../spec_helper'

describe Cranium::DSL::DatabaseDefinition do

  let(:database) { Cranium::DSL::DatabaseDefinition.new "name" }


  describe "#name" do
    it "should return the name of the database definition" do
      expect(database.name).to eq("name")
    end
  end


  describe "#connect_to" do
    it "should set the attribute to the specified value" do
      database.connect_to "value"

      expect(database.connect_to).to eq("value")
    end
  end

end
