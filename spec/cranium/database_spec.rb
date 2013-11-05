require_relative '../spec_helper'

describe Cranium::Database do

  before(:each) do
    Cranium.stub :configuration => (Cranium::Configuration.new.tap do |config|
      config.greenplum_connection_string = "connection string"
      config.loggers = "loggers"
    end)
  end

  describe ".connection" do
    before { Cranium::Database.instance_variable_set :@connection, nil }

    it "should connect to the DB" do
      Sequel.should_receive(:connect).with("connection string", :loggers => "loggers").and_return "connection"

      Cranium::Database.connection.should == "connection"
    end

    it "should return the same object every time" do
      Sequel.stub(:connect).and_return("connection1", "connection2")

      Cranium::Database.connection.should equal Cranium::Database.connection
    end
  end


  describe ".[]" do
    before do
      Cranium::Database.instance_variable_set :@connections, nil

      database_definition = Cranium::DSL::DatabaseDefinition.new :dwh
      database_definition.connect_to "other connection string"
      Cranium.stub_chain(:application, :databases, :[]).with(:dwh).and_return database_definition
    end

    it "should return the specified database connection" do
      Sequel.should_receive(:connect).with("other connection string", :loggers => "loggers").and_return "connection"

      Cranium::Database[:dwh].should == "connection"
    end

    it "should memoize the result of a previous call" do
      Sequel.stub(:connect).and_return("connection1", "connection2")

      Cranium::Database[:dwh].should equal Cranium::Database[:dwh]
    end

    it "should memoize connections by name" do
      Cranium.stub_chain(:application, :databases, :[]).with(:dwh2).and_return double(connect_to: "constring")
      Sequel.stub(:connect).and_return("connection1", "connection2")

      Cranium::Database[:dwh].should_not equal Cranium::Database[:dwh2]
    end
  end

end
