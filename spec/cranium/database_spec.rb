require_relative '../spec_helper'
require 'sequel'
require 'sequel/adapters/mock'

describe Cranium::Database do

  let(:database) { Cranium::Database }
  let(:connection) { Sequel::Mock::Database.new }
  let(:other_connection) { Sequel::Mock::Database.new }
  let(:config) do
    Cranium::Configuration.new.tap do |config|
      config.greenplum_connection_string = "connection string"
      config.loggers = "loggers"
    end
  end

  before(:each) { allow(Cranium).to receive(:configuration).and_return(config) }


  describe ".connection" do
    before { Cranium::Database.instance_variable_set :@connection, nil }

    it "should connect to the DB" do
      expect(Sequel).to receive(:connect).with("connection string", :loggers => "loggers").and_return connection

      expect(database.connection).to eq connection
    end

    it "should return the same object every time" do
      allow(Sequel).to receive(:connect).and_return(connection, other_connection)

      expect(database.connection).to eq database.connection
    end

    context 'when query logging is turned off' do
      let(:config) do
        Cranium::Configuration.new.tap do |config|
          config.greenplum_connection_string = "connection string"
          config.loggers = "loggers"
          config.log_queries = false
        end
      end

      it "should connect to the DB without any loggers" do
        expect(Sequel).to receive(:connect).with("connection string").and_return connection

        expect(database.connection).to eq connection
      end
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
      expect(Sequel).to receive(:connect).with("other connection string", :loggers => "loggers").and_return connection

      expect(database[:dwh]).to eq connection
    end

    it "should memoize the result of a previous call" do
      allow(Sequel).to receive(:connect).and_return(connection, other_connection)

      expect(database[:dwh]).to eq database[:dwh]
    end

    it "should memoize connections by name" do
      database.register_database :dwh2 do
        connect_to "other connection string 2"
      end

      allow(Sequel).to receive(:connect).and_return(connection, other_connection)

      expect(database[:dwh]).not_to eq database[:dwh2]
    end

    context 'when retry_count is specified' do
      before do
        database.register_database :dwh do
          connect_to "other connection string"
          retry_count 3
          retry_delay 15
        end
        allow(database).to receive(:sleep)
      end

      it "should retry connecting to the DB the specified number of times" do
        call_count = 0
        allow(Sequel).to receive(:connect) do
          call_count += 1
          call_count < 3 ? raise(Sequel::DatabaseConnectionError) : connection
        end

        expect(database[:dwh]).to eq connection
      end

      it "should not retry connecting to the DB more than the specified number of times" do
        allow(Sequel).to receive(:connect).exactly(4).times.and_raise(Sequel::DatabaseConnectionError)

        expect { database[:dwh] }.to raise_error(Sequel::DatabaseConnectionError)
      end

      it "should wait retry_delay seconds between connection attempts" do
        allow(Sequel).to receive(:connect).and_raise(Sequel::DatabaseConnectionError)
        expect(database).to receive(:sleep).with(15).exactly(3).times

        expect { database[:dwh] }.to raise_error(Sequel::DatabaseConnectionError)
      end
    end
  end

end
