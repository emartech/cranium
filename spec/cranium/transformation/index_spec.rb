require_relative '../../spec_helper'

describe Cranium::Transformation::Index do

  let(:index) { Cranium::Transformation::Index.new }
  let(:connection) { double "Greenplum connection" }
  let(:dimension_manager) { double "DimensionManager" }

  before(:each) do
    allow(Cranium::Database).to receive(:connection).and_return(connection)
  end



  def stub_cache_query(table_name, key_fields, value_field, result)
    allow(dimension_manager).to receive(:create_cache_for_field).with(value_field).and_return(result)
    allow(Cranium::DimensionManager).to receive(:for).with(table_name, key_fields).and_return(dimension_manager)
  end



  describe "#lookup" do
    context "the first time it's called" do
      it "should query the requested key value from the database" do
        stub_cache_query :dim_contact, [:customer_id], :contact_key, {[1234] => "contact 1",
                                                                      [2345] => "contact 2",
                                                                      [3456] => "contact 3"}

        expect(index.lookup(:contact_key, from_table: :dim_contact, match_column: :customer_id, to_value: 2345)).to eq("contact 2")
      end

      it "should query the requested multi-key value from the database" do
        stub_cache_query :dim_contact, [:key_1, :key_2], :contact_key, {[12, 34] => "contact 1",
                                                                        [23, 45] => "contact 2",
                                                                        [34, 56] => "contact 3"}

        expect(index.lookup(:contact_key, from_table: :dim_contact, match: {key_1: 23, key_2: 45})).to eq("contact 2")
      end
    end


    context "on subsequent calls" do
      it "should look up the requested value from an internal cache" do
        stub_cache_query :dim_contact, [:customer_id], :contact_key, {[1234] => "contact 1"}
        index.lookup(:contact_key, from_table: :dim_contact, match_column: :customer_id, to_value: 1234)

        stub_cache_query :dim_contact, [:customer_id], :contact_key, {[1234] => "contact 2"}
        expect(index.lookup(:contact_key, from_table: :dim_contact, match_column: :customer_id, to_value: 1234)).to eq("contact 1")
      end
    end


    it "should return :not_found if the key value was not found" do
      stub_cache_query :dim_contact, [:customer_id], :contact_key, {[1234] => "contact 2"}

      expect(index.lookup(:contact_key, from_table: :dim_contact, match_column: :customer_id, to_value: 2345)).to eq(:not_found)
    end


    it "should raise an error if both :if_not_found_then_insert and :if_not_found_then are specified" do
      expect do
        index.lookup(:contact_key, if_not_found_then: -1, if_not_found_then_insert: {})
      end.to raise_error ArgumentError, "Cannot specify both :if_not_found_then and :if_not_found_then_insert options"
    end


    context "when :if_not_found_then is specified" do
      it "should return the specified value if the lookup failed" do
        stub_cache_query :dim_contact, [:customer_id], :contact_key, {[1234] => "contact"}

        expect(index.lookup(:contact_key,
                            from_table: :dim_contact,
                            match_column: :customer_id,
                            to_value: 2345,
                            if_not_found_then: -1)).to eq(-1)
      end

      context "when the specified value is a lamba expression" do
        it "should evaluate the expression and return its value if the lookup failed" do
          stub_cache_query :dim_contact, [:customer_id], :contact_key, {[1234] => "contact"}

          expect(index.lookup(:contact_key,
                              from_table: :dim_contact,
                              match_column: :customer_id,
                              to_value: 2345,
                              if_not_found_then: -> { -1 })).to eq(-1)
        end
      end
    end


    context "when :if_not_found_then_insert is specified" do

      before(:each) do
        stub_cache_query :dim_contact, [:customer_id], :contact_key, {[1234] => "contact"}
      end

      context "when a single key is used" do
        it "should insert a new record into the specified table" do
          expect(dimension_manager).to receive(:insert).with(:contact_key, {contact_key: 1, customer_id: 2345})

          index.lookup :contact_key,
                       from_table: :dim_contact,
                       match_column: :customer_id,
                       to_value: 2345,
                       if_not_found_then_insert: {contact_key: 1, customer_id: 2345}
        end
      end

      context "when multiple keys are used" do
        it "should insert a new record into the specified table" do
          stub_cache_query :dim_contact, [:key_1, :key_2], :contact_key, {[12, 34] => "contact"}

          expect(dimension_manager).to receive(:insert).with(:contact_key, contact_key: 1, key_1: 23, key_2: 45)

          index.lookup :contact_key,
                       from_table: :dim_contact,
                       match: {key_1: 23, key_2: 45},
                       if_not_found_then_insert: {contact_key: 1, key_1: 23, key_2: 45}
        end
      end

      it "should fill out the new record's lookup key automatically" do
        expect(dimension_manager).to receive(:insert).with(:contact_key, name: "new contact", customer_id: 2345)

        index.lookup :contact_key,
                     from_table: :dim_contact,
                     match_column: :customer_id,
                     to_value: 2345,
                     if_not_found_then_insert: {name: "new contact"}
      end

      it "should overwrite the new record's lookup key if specified" do
        expect(dimension_manager).to receive(:insert).with(:contact_key, customer_id: 2345)

        index.lookup :contact_key,
                     from_table: :dim_contact,
                     match_column: :customer_id,
                     to_value: 2345,
                     if_not_found_then_insert: {customer_id: 4567}
      end

      it "should return the new record's lookup value" do
        allow(dimension_manager).to receive_messages insert: 98765

        expect(index.lookup(:contact_key,
                            from_table: :dim_contact,
                            match_column: :customer_id,
                            to_value: 2345,
                            if_not_found_then_insert: {contact_key: 98765})).to eq(98765)
      end
    end
  end

end
