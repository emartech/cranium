require_relative '../spec_helper'

describe Cranium::DatabaseRegistry do

  let(:registry) { Cranium::DatabaseRegistry.new }

  describe "#[]" do
    it "should return nil if a database with the specified name wasn't registered yet" do
      registry[:name].should be_nil
    end
  end


  describe "#register_database" do
    it "should register a new database and configure it through the block passed" do
      database = Cranium::DSL::DatabaseDefinition.new :test_database
      database.connect_to "connection string"

      registry.register_database :test_database do
        connect_to "connection string"
      end

      registry[:test_database].should == database
    end

    it "should return the newly registered source" do
      registry.register_database :test_database do end.should be_a Cranium::DSL::DatabaseDefinition
    end
  end

end
