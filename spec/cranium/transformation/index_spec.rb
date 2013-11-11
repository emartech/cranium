require_relative '../../spec_helper'

describe Cranium::Transformation::Index do

  let(:index) { Cranium::Transformation::Index.new }
  let(:connection) { double "Greenplum connection" }

  before(:each) do
    Cranium::Database.stub connection: connection
  end



  def stub_cache_query(table_name, key_fields, value_field, result)
    dimension_manager = double "DimensionManager"
    dimension_manager.stub(:create_cache_for_field).with(value_field).and_return(result)
    Cranium::DimensionManager.stub(:for).with(table_name, key_fields).and_return(dimension_manager)
  end



  describe "#lookup" do
    context "the first time it's called" do
      it "should query the requested key value from the database" do
        stub_cache_query :dim_contact, [:customer_id], :contact_key, { [1234] => "contact 1",
                                                                     [2345] => "contact 2",
                                                                     [3456] => "contact 3" }

        index.lookup(:contact_key, from_table: :dim_contact, match_column: :customer_id, to_value: 2345).should == "contact 2"
      end

      it "should query the requested multi-key value from the database" do
        stub_cache_query :dim_contact, [:key_1, :key_2], :contact_key, { [12,34] => "contact 1",
                                                                       [23,45] => "contact 2",
                                                                       [34,56] => "contact 3" }

        index.lookup(:contact_key, from_table: :dim_contact, match: {key_1: 23, key_2: 45 }).should == "contact 2"
      end
    end


    context "on subsequent calls" do
      it "should look up the requested value from an internal cache" do
        stub_cache_query :dim_contact, [:customer_id], :contact_key, { [1234] => "contact 1" }
        index.lookup(:contact_key, from_table: :dim_contact, match_column: :customer_id, to_value: 1234)

        stub_cache_query :dim_contact, [:customer_id], :contact_key, { [1234] => "contact 2" }
        index.lookup(:contact_key, from_table: :dim_contact, match_column: :customer_id, to_value: 1234).should == "contact 1"
      end
    end


    it "should return :not_found if the key value was not found" do
      stub_cache_query :dim_contact, [:customer_id], :contact_key, { [1234] => "contact 2" }

      index.lookup(:contact_key, from_table: :dim_contact, match_column: :customer_id, to_value: 2345).should == :not_found
    end


    it "should raise an error if both :if_not_found_then_insert and :if_not_found_then are specified" do
      expect do
        index.lookup(:contact_key, if_not_found_then: -1, if_not_found_then_insert: {})
      end.to raise_error ArgumentError, "Cannot specify both :if_not_found_then and :if_not_found_then_insert options"
    end


    context "when :if_not_found_then is specified" do
      it "should return the specified value if the lookup failed" do
        stub_cache_query :dim_contact, [:customer_id], :contact_key, { [1234] => "contact" }

        index.lookup(:contact_key,
                     from_table: :dim_contact,
                     match_column: :customer_id,
                     to_value: 2345,
                     if_not_found_then: -1).should == -1
      end
    end


    context "when :if_not_found_then_insert is specified" do
      let(:dimension_manager) { double "DimensionManager" }

      before(:each) do
        Cranium::DimensionManager.stub(:for).with(:dim_contact, :contact_key).and_return(dimension_manager)
        stub_cache_query :dim_contact, [:customer_id], :contact_key, { [1234] => "contact" }
      end

      context "when a single key is used" do
        it "should insert a new record into the specified table" do
          dimension_manager.should_receive(:insert).with(customer_id: 2345)

          index.lookup :contact_key,
                       from_table: :dim_contact,
                       match_column: :customer_id,
                       to_value: 2345,
                       if_not_found_then_insert: { customer_id: 2345 }
        end
      end

      context "when multiple keys are used" do
        it "should insert a new record into the specified table" do
          stub_cache_query :dim_contact, [:key_1, :key_2], :contact_key, { [12,34] => "contact" }

          dimension_manager.should_receive(:insert).with(key_1: 23, key_2: 45)

          index.lookup :contact_key,
                       from_table: :dim_contact,
                       match: {key_1: 23, key_2: 45},
                       if_not_found_then_insert: { key_1: 23, key_2: 45 }
        end
      end

      it "should fill out the new record's lookup key automatically" do
        dimension_manager.should_receive(:insert).with(name: "new contact", customer_id: 2345)

        index.lookup :contact_key,
                     from_table: :dim_contact,
                     match_column: :customer_id,
                     to_value: 2345,
                     if_not_found_then_insert: { name: "new contact" }
      end

      it "should overwrite the new record's lookup key if specified" do
        dimension_manager.should_receive(:insert).with(customer_id: 2345)

        index.lookup :contact_key,
                     from_table: :dim_contact,
                     match_column: :customer_id,
                     to_value: 2345,
                     if_not_found_then_insert: { customer_id: 4567 }
      end

      it "should return the new record's lookup value" do
        dimension_manager.stub insert: 98765

        index.lookup(:contact_key,
                     from_table: :dim_contact,
                     match_column: :customer_id,
                     to_value: 2345,
                     if_not_found_then_insert: { contact_key: 98765 }).should == 98765
      end
    end
  end

end
