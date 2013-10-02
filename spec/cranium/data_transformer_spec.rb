require_relative '../spec_helper'

describe Cranium::DataTransformer do
  describe "#transform" do
    it "should yield the transformation block for each record in the source file" do
      transform_definition = double("transform definition")
      Cranium::DataTransformer.new.transform transform_definition do |record|

      end
    end
  end

end