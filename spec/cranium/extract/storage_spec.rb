require_relative '../../spec_helper'

describe Cranium::Extract::Storage do

  let(:storage) { Cranium::Extract::Storage.new :extract_name }
  let(:storage_dir) { "/storage/directory/.cranium" }
  let(:storage_file) { "#{storage_dir}/extracts" }

  before do
    allow(Cranium).to receive(:configuration).and_return(Cranium::Configuration.new.tap { |config| config.storage_directory = storage_dir })
  end

  describe "#last_value_of" do
    context "when storage file doesn't exist" do
      it "should return nil if no storage file was created yet" do
        allow(File).to receive(:exists?).with(storage_file).and_return(false)
        expect(storage.last_value_of(:field)).to eq(nil)
      end
    end

    context "when storage file already exists" do
      before { allow(File).to receive(:exists?).with(storage_file).and_return(true) }

      it "should return nil if no value was saved for this extract yet" do
        allow(File).to receive(:read).with(storage_file).and_return(YAML.dump(other_extract_name: {last_values: {}}))
        expect(storage.last_value_of(:field)).to eq(nil)
      end

      it "should return nil if no value was saved for the field" do
        allow(File).to receive(:read).with(storage_file).and_return(YAML.dump(extract_name: {last_values: {}}))
        expect(storage.last_value_of(:field)).to eq(nil)
      end

      it "should return the last saved value of the specified field" do
        allow(File).to receive(:read).with(storage_file).and_return(YAML.dump(extract_name: {last_values: {field: 15}}))
        expect(storage.last_value_of(:field)).to eq(15)
      end
    end
  end


  describe "#save_last_value_of" do
    context "when storage file doesn't exist" do
      before { allow(File).to receive(:exists?).with(storage_file).and_return(false) }

      it "should create the storage file and save the specified value if the storage directory already exists" do
        allow(Dir).to receive(:exists?).with(storage_dir).and_return(true)

        expect(File).to receive(:write).with(storage_file, YAML.dump(extract_name: {last_values: {field: 15}}))

        storage.save_last_value_of(:field, 15)
      end

      it "should create the storage directory if it doesn't exist yet" do
        allow(Dir).to receive(:exists?).with(storage_dir).and_return(false)
        allow(File).to receive :write

        expect(FileUtils).to receive(:mkdir_p).with(storage_dir)

        storage.save_last_value_of(:field, 15)
      end
    end

    context "when there are previously saved values" do
      before do
        allow(Dir).to receive(:exists?).with(storage_dir).and_return(true)
        allow(File).to receive(:exists?).with(storage_file).and_return(true)
      end

      it "should overwrite the specified field's value and preserve all others" do
        allow(File).to receive(:read).with(storage_file).and_return(YAML.dump({
                                                                                extract_name: {
                                                                                  last_values: {
                                                                                    field1: 1,
                                                                                    field2: 2,
                                                                                    field3: 3
                                                                                  }
                                                                                }
                                                                              }))

        expect(File).to receive(:write).with(storage_file, YAML.dump({
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
        allow(File).to receive(:read).with(storage_file).and_return(YAML.dump({
                                                                                other_extract_name: {
                                                                                  last_values: {
                                                                                    field1: 1,
                                                                                    field2: 2,
                                                                                    field3: 3
                                                                                  }
                                                                                }
                                                                              }))

        expect(File).to receive(:write).with(storage_file, YAML.dump({
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
