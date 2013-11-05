require_relative '../spec_helper'

describe Cranium::Database do

  let(:database) { Cranium::Database }

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

      database.connection.should == "connection"
    end

    it "should return the same object every time" do
      Sequel.stub(:connect).and_return("connection1", "connection2")

      database.connection.should equal database.connection
    end
  end


  describe ".[]" do
    before do
      database.instance_variable_set :@connections, nil
      database.instance_variable_set :@definitions, nil

      database.register_database :dwh do
        connect_to "other connection string"
      end
    end

    it "should return the specified database connection" do
      Sequel.should_receive(:connect).with("other connection string", :loggers => "loggers").and_return "connection"

      database[:dwh].should == "connection"
    end

    it "should memoize the result of a previous call" do
      Sequel.stub(:connect).and_return("connection1", "connection2")

      database[:dwh].should equal database[:dwh]
    end

    it "should memoize connections by name" do
      database.register_database :dwh2 do
        connect_to "other connection string 2"
      end

      Sequel.stub(:connect).and_return("connection1", "connection2")

      database[:dwh].should_not equal database[:dwh2]
    end
  end

end
