require_relative '../spec_helper'
require 'sequel'
require 'sequel/adapters/mock'

describe Cranium::Database do

  let(:database) { Cranium::Database }

  before(:each) do
    allow(Cranium).to receive(:configuration).and_return(Cranium::Configuration.new.tap do |config|
                                                           config.greenplum_connection_string = "connection string"
                                                           config.loggers = "loggers"
                                                         end)
  end


  describe ".connection" do
    before { Cranium::Database.instance_variable_set :@connection, nil }

    let(:connection) { Sequel::Mock::Database.new }

    it "should connect to the DB" do
      Sequel.should_receive(:connect).with("connection string", :loggers => "loggers").and_return connection

      expect(database.connection).to eq connection
    end

    it "should return the same object every time" do
      allow(Sequel).to receive(:connect).and_return(connection)

      expect(database.connection).to eq database.connection
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
      expect(Sequel).to receive(:connect).with("other connection string", :loggers => "loggers").and_return "connection"

      expect(database[:dwh]).to eq "connection"
    end

    it "should memoize the result of a previous call" do
      allow(Sequel).to receive(:connect).and_return("connection1", "connection2")

      expect(database[:dwh]).to eq database[:dwh]
    end

    it "should memoize connections by name" do
      database.register_database :dwh2 do
        connect_to "other connection string 2"
      end

      allow(Sequel).to receive(:connect).and_return("connection1", "connection2")

      expect(database[:dwh]).not_to eq database[:dwh2]
    end
  end

end
