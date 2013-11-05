require_relative '../spec_helper'

describe Cranium::DSL do

  let(:dsl_object) { Object.new.tap { |object| object.extend Cranium::DSL } }

  describe "#database" do
    it "should register a database connection in the application" do
      Cranium.application.should_receive(:register_database).with(:name)

      dsl_object.database(:name)
    end
  end


  describe "#source" do
    it "should register a source in the application" do
      Cranium.application.should_receive(:register_source).with(:name)

      dsl_object.source(:name)
    end
  end


  describe "#archive" do
    it "should archive files for the specified sources" do
      Cranium.application.stub sources: { first_source: double(files: ["file1", "file2"]),
                                          second_source: double(files: ["file3"]),
                                          third_source: double(files: ["file4"]) }

      Cranium::Archiver.should_receive(:archive).with "file1", "file2"
      Cranium::Archiver.should_receive(:archive).with "file3"

      dsl_object.archive :first_source, :second_source
    end
  end


  describe "#deduplicate" do
    it "should call transform with correct source and target arguments" do
      dsl_object.should_receive(:transform).with(:sales_items => :products)
      dsl_object.deduplicate :sales_items, into: :products, by: [:item]
    end
  end


end
