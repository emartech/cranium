require_relative '../../spec_helper'

describe Cranium::DSL::DatabaseDefinition do

  let(:database) { Cranium::DSL::DatabaseDefinition.new "name" }


  describe "#name" do
    it "should return the name of the database definition" do
      expect(database.name).to eq("name")
    end
  end


  describe "#connect_to" do
    it "should set the attribute to the specified value" do
      database.connect_to "value"

      expect(database.connect_to).to eq("value")
    end
  end


  describe "#retry_count" do
    context 'when not set' do
      it "should return 0 by default" do
        expect(database.retry_count).to eq(0)
      end
    end

    context 'when set' do
      it "should return the number of retries specified for the database" do
        database.retry_count 3

        expect(database.retry_count).to eq(3)
      end
    end
  end


  describe "#retry_delay" do
    context 'when not set' do
      it "should return 0 by default" do
        expect(database.retry_delay).to eq(0)
      end
    end

    context 'when set' do
      it "should return the number of retries specified for the database" do
        database.retry_delay 15

        expect(database.retry_delay).to eq(15)
      end
    end
  end

end
