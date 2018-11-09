require_relative '../spec_helper'

describe Cranium::DSL do

  let(:dsl_object) { Object.new.tap { |object| object.extend Cranium::DSL } }

  describe "#database" do
    it "should register a database connection in the application" do
      block = lambda {}

      expect(Cranium::Database).to receive(:register_database) do |arg, &blk|
        expect(arg).to eq :name
        expect(blk).to be block
      end

      dsl_object.database(:name, &block)
    end
  end


  describe "#source" do
    it "should register a source in the application" do
      expect(Cranium.application).to receive(:register_source).with(:name)

      dsl_object.source(:name)
    end
  end


  describe "#extract" do
    it "should create an extract definition and execute it" do
      extract_definition = double "ExtractDefinition"
      block = lambda {}

      allow(Cranium::DSL::ExtractDefinition).to receive(:new).with(:contacts).and_return(extract_definition)
      expect(extract_definition).to receive(:instance_eval) { |&blk| expect(blk).to be block }

      extractor = double "DataExtractor"
      allow(Cranium::Extract::DataExtractor).to receive_messages new: extractor
      expect(extractor).to receive(:execute).with(extract_definition)

      dsl_object.extract :contacts, &block
    end
  end


  describe "#deduplicate" do
    it "should call transform with correct source and target arguments" do
      expect(dsl_object).to receive(:transform).with(:sales_items => :products)
      dsl_object.deduplicate :sales_items, into: :products, by: [:item]
    end
  end


  describe "#import" do
    it "should create an import definition and execute it" do
      import_definition = double "ImportDefinition"
      block = lambda {}

      allow(Cranium::DSL::ImportDefinition).to receive(:new).with(:contacts).and_return(import_definition)
      expect(import_definition).to receive(:instance_eval) { |&blk| expect(blk).to be block }

      importer = double "DataImporter"
      allow(Cranium::DataImporter).to receive_messages new: importer
      expect(importer).to receive(:import).with(import_definition)

      dsl_object.import :contacts, &block
    end
  end


  describe "#archive" do
    it "should archive files for the specified sources" do
      allow(Cranium.application).to receive_messages sources: {first_source: double(files: ["file1", "file2"]),
                                         second_source: double(files: ["file3"]),
                                         third_source: double(files: ["file4"])}

      expect(Cranium::Archiver).to receive(:archive).with "file1", "file2"
      expect(Cranium::Archiver).to receive(:archive).with "file3"

      dsl_object.archive :first_source, :second_source
    end
  end


  describe "#remove" do
    it "should remove files for the specified sources" do
      allow(Cranium.application).to receive_messages sources: {first_source: double(files: ["file1", "file2"]),
                                         second_source: double(files: ["file3"]),
                                         third_source: double(files: ["file4"])}

      expect(Cranium::Archiver).to receive(:remove).with "file1", "file2"
      expect(Cranium::Archiver).to receive(:remove).with "file3"

      dsl_object.remove :first_source, :second_source
    end
  end


  describe "#move" do
    let(:target_directory) { "/tmp/target" }

    it "should move files for the specified sources" do
      allow(Cranium.application).to receive_messages sources: {first_source: double(files: ["file1", "file2"]),
                                                               second_source: double(files: ["file3"]),
                                                               third_source: double(files: ["file4"])}

      expect(Cranium::Archiver).to receive(:move).with "file1", "file2", target_directory: target_directory
      expect(Cranium::Archiver).to receive(:move).with "file3", target_directory: target_directory

      dsl_object.move :first_source, :second_source, to: target_directory
    end
  end


  describe "#sequence" do
    it "should return a sequence with the specified name" do
      result = dsl_object.sequence "test_sequence"

      expect(result).to be_a Cranium::Transformation::Sequence
      expect(result.name).to eq("test_sequence")
    end
  end


  describe "#after" do
    it "should register a new after hook for the application" do
      block = -> {}

      expect(Cranium.application).to receive(:register_hook).with(:after) { |&blk| expect(blk).to be block }

      dsl_object.after &block
    end
  end
end
