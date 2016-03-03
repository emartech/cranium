require_relative 'spec_helper'

describe Cranium do

  describe ".application" do
    it "should return an Application object" do
      expect(Cranium.application).to be_a Cranium::Application
    end

    it "should return a singleton" do
      expect(Cranium.application).to equal Cranium.application
    end
  end


  describe ".configure" do
    it "should set or modify the existing configuration" do
      Cranium.configure do |config|
        config.greenplum_connection_string = "greenplum connection"
        config.mysql_connection_string = "mysql connection"
      end

      Cranium.configure do |config|
        config.greenplum_connection_string = "new greenplum connection"
      end

      expect(Cranium.configuration.greenplum_connection_string).to eq("new greenplum connection")
      expect(Cranium.configuration.mysql_connection_string).to eq("mysql connection")
    end
  end


  describe ".configuration" do
    it "should return the configuration" do
      expect(Cranium.configuration).to be_a Cranium::Configuration
    end

    it "should not let the user modify the configuration" do
      expect { Cranium.configuration.greenplum_connection_string = "constring" }.to raise_error(RuntimeError)
    end
  end


  describe ".load_arguments" do
    it "should return the load arguments of the application" do
      app = double "application", load_arguments: "load_arguments"
      allow(Cranium).to receive(:application).and_return(app)

      expect(Cranium.load_arguments).to eq "load_arguments"
    end
  end

end
