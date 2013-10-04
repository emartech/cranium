require_relative '../../spec_helper'

describe Cranium::Transformation::Index do

  let(:index) { Cranium::Transformation::Index.new }
  let(:connection) { double "Greenplum connection" }

  before(:each) do
    Cranium::Database.stub connection: connection
  end



  def stub_cache_query(table_name, key_field, value_field, result)
    table_dataset = double "table dataset"
    connection.stub(:[]).with(table_name).and_return table_dataset
    table_dataset.stub(:select_map).with([key_field, value_field]).and_return(result.to_a)
  end



  describe "#lookup" do
    context "the first time it's called" do
      it "should query the requested value from the database" do
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
  end

end
