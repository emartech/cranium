require_relative '../../spec_helper'

describe Cranium::DSL::ImportDefinition do

  let(:import) { Cranium::DSL::ImportDefinition.new "import_name" }

  describe "#into" do
    it "should set the attribute to the specified value" do
      import.into "new value"

      import.into.should == "new value"
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
    context "when called with a Hash" do
      it "should store the field associations" do
        import.put :item => :id, :title => :name

        import.field_associations.should == { :item => :id, :title => :name }
      end
    end

    context "when called with a Symbol" do
      it "should store a field association between fields with the same name" do
        import.put :item

        import.field_associations.should == { :item => :item }
      end
    end

    context "when called with an unsupported type" do
      it "should raise an error" do
        expect { import.put "unsupported" }.to raise_error ArgumentError, "Unsupported argument for Import::put"
      end
    end

    context "when called multiple times" do
      it "should merge all specified associations" do
        import.put :item => :id
        import.put :title => :name
        import.put :category => :category, :brand => :brand

        import.field_associations.should == {
          :item => :id,
          :title => :name,
          :category => :category,
          :brand => :brand
        }
      end
    end
  end


  describe "#merge_fields" do
    context "when no fields are set" do
      it "should return empty hash" do
        import.merge_fields.should == {}
      end
    end
  end


  describe "#merge_on" do
    context "when called with a Hash" do
      it "should set merge field associations" do
        import.merge_on :item => :id, :title => :name

        import.merge_fields.should == { :item => :id, :title => :name }
      end
    end

    context "when called with a Symbol" do
      it "should store a merge field association between fields with the same name" do
        import.merge_on :item

        import.merge_fields.should == { :item => :item }
      end
    end

    context "when called with an unsupported type" do
      it "should raise an error" do
        expect { import.merge_on "unsupported" }.to raise_error ArgumentError, "Unsupported argument for Import::merge_on"
      end
    end

    context "when called multiple times" do
      it "should overwrite existing merge fields" do
        import.merge_on :item => :id
        import.merge_on :title => :name

        import.merge_fields.should == { :title => :name }
      end
    end
  end

end
