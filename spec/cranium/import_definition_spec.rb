require_relative '../spec_helper'

describe Cranium::ImportDefinition do

  let(:import) { Cranium::ImportDefinition.new "import_name" }

  describe "#to" do
    it "should set the attribute to the specified value" do
      import.to "new value"

      import.to.should == "new value"
    end
  end


  describe "#name" do
    it "should return the name of the import definition" do
      import.name.should == "import_name"
    end
  end


  describe "#field_associations" do
    context "when no fields are set" do
      it "should return empty hash" do
        import.field_associations.should == {}
      end
    end
  end


  describe "#put" do
    it "should add field associations" do
      import.put :item => :id
      import.put :title => :name

      import.field_associations.should == {
        :item => :id,
        :title => :name
      }
    end
  end

end
