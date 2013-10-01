require_relative '../spec_helper'

describe Cranium::DSL do

  let(:dsl_object) { Object.new.tap { |object| object.extend Cranium::DSL } }

  describe "#source" do
    it "should register a source in the application" do
      Cranium.application.should_receive(:register_source).with(:name)

      dsl_object.source(:name)
    end
  end

end
