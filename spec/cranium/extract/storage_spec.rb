require_relative '../../spec_helper'

describe Cranium::Extract::Storage do

  let(:storage) { Cranium::Extract::Storage.new :extract_name }
  let(:storage_dir) { "/storage/directory/.cranium" }
  let(:storage_file) { "#{storage_dir}/extracts" }

  before { Cranium.stub configuration: Cranium::Configuration.new.tap { |config| config.storage_directory = storage_dir } }

  describe "#last_value_of" do
    context "when storage file doesn't exist" do
      it "should return nil if no storage file was created yet" do
        File.stub(:exists?).with(storage_file).and_return(false)
        storage.last_value_of(:field).should == nil
      end
    end

    context "when storage file already exists" do
      before { File.stub(:exists?).with(storage_file).and_return(true) }

      it "should return nil if no value was saved for this extract yet" do
        File.stub(:read).with(storage_file).and_return(YAML.dump(other_extract_name: { last_values: {} }))
        storage.last_value_of(:field).should == nil
      end

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
      before { File.stub(:exists?).with(storage_file).and_return(false) }

      it "should create the storage file and save the specified value if the storage directory already exists" do
        Dir.stub(:exists?).with(storage_dir).and_return(true)

        File.should_receive(:write).with(storage_file, YAML.dump(extract_name: { last_values: { field: 15 } }))

        storage.save_last_value_of(:field, 15)
      end

      it "should create the storage directory if it doesn't exist yet" do
        Dir.stub(:exists?).with(storage_dir).and_return(false)
        File.stub :write

        FileUtils.should_receive(:mkdir_p).with(storage_dir)

        storage.save_last_value_of(:field, 15)
      end
    end

    context "when there are previously saved values" do
      before do
        Dir.stub(:exists?).with(storage_dir).and_return(true)
        File.stub(:exists?).with(storage_file).and_return(true)
      end

      it "should overwrite the specified field's value and preserve all others" do
        File.stub(:read).with(storage_file).and_return(YAML.dump({
                                                                   extract_name: {
                                                                     last_values: {
                                                                       field1: 1,
                                                                       field2: 2,
                                                                       field3: 3
                                                                     }
                                                                   }
                                                                 }))

        File.should_receive(:write).with(storage_file, YAML.dump({
                                                                   extract_name: {
                                                                     last_values: {
                                                                       field1: 1,
                                                                       field2: 5,
                                                                       field3: 3
                                                                     }
                                                                   }
                                                                 }))

        storage.save_last_value_of(:field2, 5)
      end

      it "should create the new entry if it doesn't exist yet" do
        File.stub(:read).with(storage_file).and_return(YAML.dump({
                                                                   other_extract_name: {
                                                                     last_values: {
                                                                       field1: 1,
                                                                       field2: 2,
                                                                       field3: 3
                                                                     }
                                                                   }
                                                                 }))

        File.should_receive(:write).with(storage_file, YAML.dump({
                                                                   other_extract_name: {
                                                                     last_values: {
                                                                       field1: 1,
                                                                       field2: 2,
                                                                       field3: 3
                                                                     }
                                                                   },
                                                                   extract_name: {
                                                                     last_values: {
                                                                       field2: 5
                                                                     }
                                                                   }
                                                                 }))

        storage.save_last_value_of(:field2, 5)
      end
    end
  end

end
