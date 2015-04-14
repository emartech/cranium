require_relative '../../spec_helper'

describe Cranium::DSL::ImportDefinition do

  let(:import) { Cranium::DSL::ImportDefinition.new "import_name" }

  describe "#into" do
    it "should set the attribute to the specified value" do
      import.into "new value"

      expect(import.into).to eq("new value")
    end
  end


  describe "#name" do
    it "should return the name of the import definition" do
      expect(import.name).to eq("import_name")
    end
  end


  describe "#field_associations" do
    context "when no fields are set" do
      it "should return empty hash" do
        expect(import.field_associations).to eq({})
      end
    end
  end


  describe "#put" do
    context "when called with a Hash" do
      it "should store the field associations" do
        import.put :item => :id, :title => :name

        expect(import.field_associations).to eq({:item => :id, :title => :name})
      end
    end

    context "when called with a Symbol" do
      it "should store a field association between fields with the same name" do
        import.put :item

        expect(import.field_associations).to eq({:item => :item})
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

        expect(import.field_associations).to eq({
            :item => :id,
            :title => :name,
            :category => :category,
            :brand => :brand
        })
      end
    end
  end


  describe "#merge_fields" do
    context "when no fields are set" do
      it "should return empty hash" do
        expect(import.merge_fields).to eq({})
      end
    end
  end


  describe "#merge_on" do
    context "when called with a Hash" do
      it "should set merge field associations" do
        import.merge_on :item => :id, :title => :name

        expect(import.merge_fields).to eq({:item => :id, :title => :name})
      end
    end

    context "when called with a Symbol" do
      it "should store a merge field association between fields with the same name" do
        import.merge_on :item

        expect(import.merge_fields).to eq({:item => :item})
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

        expect(import.merge_fields).to eq({:title => :name})
      end
    end
  end


  describe "#delete_insert_on" do

    it "should return an empty array when no value was set" do
      expect(import.delete_insert_on).to eq([])
    end


    it "should store and return the value passed" do
      import.delete_insert_on :some_field

      expect(import.delete_insert_on).to eq([:some_field])
    end


    it "should handle multiple arguments" do
      import.delete_insert_on :some_field, :another_field

      expect(import.delete_insert_on).to eq([:some_field, :another_field])
    end

  end

end
