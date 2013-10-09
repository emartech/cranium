require_relative '../spec_helper'

describe Cranium::DSL do

  let(:dsl_object) { Object.new.tap { |object| object.extend Cranium::DSL } }

  describe "#source" do
    it "should register a source in the application" do
      Cranium.application.should_receive(:register_source).with(:name)

      dsl_object.source(:name)
    end
  end


  describe "#archive" do

    it "should archive files for the specified sources" do
      source_mocks = {
          first_source: double,
          second_source: double,
          third_source: double
      }

      source_mocks[:first_source].stub(:files).and_return ["file1", "file2"]
      source_mocks[:second_source].stub(:files).and_return ["file3"]
      source_mocks[:third_source].stub(:files).and_return ["file4"]

      Cranium.application.stub(:sources).and_return source_mocks

      Cranium::Archiver.should_receive(:archive).with "file1", "file2"
      Cranium::Archiver.should_receive(:archive).with "file3"

      dsl_object.archive :first_source, :second_source
    end

  end

end
