require_relative '../../spec_helper'

describe Cranium::DSL::ExtractDefinition do

  let(:extract) { Cranium::DSL::ExtractDefinition.new :extract_name }


  describe "#name" do
    it "should return the name of the extract definition" do
      extract.name.should == :extract_name
    end
  end


  describe "#from" do
    it "should set the attribute to the specified value" do
      extract.from :database
      extract.from.should == :database
    end
  end


  describe "#query" do
    it "should set the attribute to the specified value" do
      extract.query "extract query"
      extract.query.should == "extract query"
    end
  end


  describe "#incrementally_by" do
    it "should set the attribute to the specified value" do
      extract.incrementally_by :id
      extract.incrementally_by.should == :id
    end
  end


  describe "#last_extracted_value_of" do
    let(:storage) { double "extract storage" }
    before { Cranium::Extract::Storage.stub(:new).with(:extract_name).and_return(storage) }

    context "when there is no last extracted value for the field" do
      before { storage.stub(:last_value_of).with(:id).and_return(nil) }

      it "should return nil" do
        extract.last_extracted_value_of(:id).should be_nil
      end

      it "should return the default value if one was specified" do
        extract.last_extracted_value_of(:id, 0).should == 0
      end
    end

    it "should return the last extracted value of the field" do
      storage.stub(:last_value_of).with(:id).and_return(15)
      extract.last_extracted_value_of(:id).should == 15
    end
  end

end
