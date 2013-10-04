require_relative '../spec_helper'
require 'ostruct'

describe Cranium::Database do

  describe ".connection" do

    before(:each) { Cranium::Database.instance_variable_set :@connection, nil }

    it "should connect to the DB" do
      Cranium.stub configuration: OpenStruct.new(
          greenplum_connection_string: "connection_string",
          loggers: "loggers"
      )

      Sequel.should_receive(:connect).with("connection_string", :loggers => "loggers").and_return "connection"

      Cranium::Database.connection.should == "connection"
    end


    it "should return the same object every time" do
      Sequel.stub(:connect).and_return("connection1", "conenction2")

      Cranium::Database.connection.should equal Cranium::Database.connection
    end

  end

end