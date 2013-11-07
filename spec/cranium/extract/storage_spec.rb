require_relative '../../spec_helper'
require 'ostruct'

describe Cranium::Extract::Storage do

  before { Cranium.stub configuration: OpenStruct.new(working_directory: "/working/directory/.cranium") }

  let(:storage) { Cranium::Extract::Storage.new :extract_name }
  let(:storage_file) { "#{Cranium.configuration.working_directory}/extracts" }

  describe "#last_value_of" do
    context "when storage file doesn't exist" do
      it "should return nil if no storage file was created yet" do
        File.stub(:exists?).with(storage_file).and_return(false)
        storage.last_value_of(:field).should == nil
      end
    end

    context "when storage file already exists" do
      before { File.stub(:exists?).with(storage_file).and_return(true) }

      it "should return nil if no value was saved for the field" do
        File.stub(:read).with(storage_file).and_return(YAML.dump(extract_name: { last_values: {} }))
        storage.last_value_of(:field).should == nil
      end

      it "should return the last saved value of the specified field" do
        File.stub(:read).with(storage_file).and_return(YAML.dump(extract_name: { last_values: { field: 15 } }))
        storage.last_value_of(:field).should == 15
      end
    end
  end


  describe "#save_last_value_of" do
    context "when storage file doesn't exist" do
      it "should create the storage file and save the specified value" do
        File.stub(:exists?).with(storage_file).and_return(false)

        File.should_receive(:write).with(storage_file, YAML.dump(extract_name: { last_values: { field: 15 } }))

        storage.save_last_value_of(:field, 15)
      end
    end

    context "when there are previously saved values" do
      before { File.stub(:exists?).with(storage_file).and_return(true) }

      it "should overwrite the specified field's value and preserve all others" do
        File.stub(:read).with(storage_file).and_return(YAML.dump({
                                                                   extract_name:
                                                                     {
                                                                       last_values: {
                                                                         field1: 1,
                                                                         field2: 2,
                                                                         field3: 3
                                                                       }
                                                                     }
                                                                 }))

        File.should_receive(:write).with(storage_file, YAML.dump({
                                                                   extract_name:
                                                                     {
                                                                       last_values: {
                                                                         field1: 1,
                                                                         field2: 5,
                                                                         field3: 3
                                                                       }
                                                                     }
                                                                 }))

        storage.save_last_value_of(:field2, 5)
      end
    end
  end

end
