require_relative '../../spec_helper'

describe Cranium::Transformation::Index do

  let(:index) { Cranium::Transformation::Index.new }
  let(:connection) { double "Greenplum connection" }

  before(:each) do
    Cranium::Database.stub connection: connection
  end



  def stub_cache_query(table_name, key_field, value_field, result)
    dimension_manager = double "DimensionManager"
    Cranium::DimensionManager.stub(:for).with(table_name, key_field).and_return(dimension_manager)
    dimension_manager.stub(:create_cache_for_field).with(value_field).and_return(result)
  end



  describe "#lookup" do
    context "the first time it's called" do
      it "should query the requested key value from the database" do
        stub_cache_query :dim_contact, :customer_id, :contact_key, { 1234 => "contact 1",
                                                                     2345 => "contact 2",
                                                                     3456 => "contact 3" }

        index.lookup(:contact_key, from_table: :dim_contact, match_column: :customer_id, to_value: 2345).should == "contact 2"
      end
    end

    context "on subsequent calls" do
      it "should look up the requested value from an internal cache" do
        stub_cache_query :dim_contact, :customer_id, :contact_key, { 1234 => "contact 1" }
        index.lookup(:contact_key, from_table: :dim_contact, match_column: :customer_id, to_value: 1234)

        stub_cache_query :dim_contact, :customer_id, :contact_key, { 1234 => "contact 2" }
        index.lookup(:contact_key, from_table: :dim_contact, match_column: :customer_id, to_value: 1234).should == "contact 1"
      end
    end

    it "should return :not_found if the key value was not found" do
      stub_cache_query :dim_contact, :customer_id, :contact_key, { 1234 => "contact 2" }

      index.lookup(:contact_key, from_table: :dim_contact, match_column: :customer_id, to_value: 2345).should == :not_found
    end

    context "when :if_not_found_then_insert is specified" do
      it "should insert a new record into the specified table" do
        stub_cache_query :dim_contact, :customer_id, :contact_key, { 1234 => "contact 2" }

        dimension_manager = double "DimensionManager"
        Cranium::DimensionManager.stub(:for).with(:dim_contact, :contact_key).and_return(dimension_manager)
        dimension_manager.should_receive(:insert).with({ name: "test name", customer_id: 2345 })

        index.lookup(:contact_key,
                     from_table: :dim_contact,
                     match_column: :customer_id,
                     to_value: 2345,
                     if_not_found_then_insert: { name: "test name", customer_id: 4567 })
      end
    end
  end

end
