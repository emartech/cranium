require_relative '../../spec_helper'

describe Cranium::DSL::ExtractDefinition do

  let(:extract) { Cranium::DSL::ExtractDefinition.new :extract_name }


  describe "#name" do
    it "should return the name of the extract definition" do
      expect(extract.name).to eq(:extract_name)
    end
  end


  describe "#storage" do
    it "should return the persistent storage corresponding to the extract" do
      expect(extract.storage).to be_a Cranium::Extract::Storage
    end
  end


  describe "#from" do
    it "should set the attribute to the specified value" do
      extract.from :database
      expect(extract.from).to eq(:database)
    end
  end


  describe "#query" do
    it "should set the attribute to the specified value" do
      extract.query "extract query"
      expect(extract.query).to eq("extract query")
    end
  end


  describe "#columns" do
    it "should set the attribute to the specified value" do
      extract.query %w(id name status)
      expect(extract.query).to eq(%w(id name status))
    end
  end


  describe "#incrementally_by" do
    it "should set the attribute to the specified value" do
      extract.incrementally_by :id
      expect(extract.incrementally_by).to eq(:id)
    end
  end


  describe "#last_extracted_value_of" do
    let(:storage) { double "extract storage" }
    before { allow(Cranium::Extract::Storage).to receive(:new).with(:extract_name).and_return(storage) }

    context "when there is no last extracted value for the field" do
      before { allow(storage).to receive(:last_value_of).with(:id).and_return(nil) }

      it "should return nil" do
        expect(extract.last_extracted_value_of(:id)).to be_nil
      end

      it "should return the default value if one was specified" do
        expect(extract.last_extracted_value_of(:id, 0)).to eq(0)
      end
    end

    it "should return the last extracted value of the field" do
      allow(storage).to receive(:last_value_of).with(:id).and_return(15)
      expect(extract.last_extracted_value_of(:id)).to eq(15)
    end
  end

end
