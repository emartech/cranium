require_relative '../../spec_helper'

describe Cranium::DSL::SourceDefinition do

  let(:source) { Cranium::DSL::SourceDefinition.new "name" }


  { file: "name.csv",
    delimiter: ",",
    escape: '"',
    quote: '"',
    encoding: "UTF-8" }.each do |attribute, default_value|

    describe "#attribute" do
      context "if called without a parameter" do
        it "should return the (default) value of the attribute" do
          source.send(attribute).should == default_value
        end
      end

      context "if called with a parameter" do
        it "should set the attribute to the specified value" do
          source.send(attribute, "new value")

          source.send(attribute).should == "new value"
        end
      end
    end

  end


  describe "#fields" do
    it "should return an empty Hash if no fields are set" do
      source.fields.should == {}
    end

    it "should return the fields and types that were set" do
      source.field :field1, String
      source.field :field2, Fixnum

      source.fields.should == {
        field1: String,
        field2: Fixnum
      }
    end
  end

end
