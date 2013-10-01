require_relative 'spec_helper'

describe Cranium do

  describe ".application" do
    it "should return an Application object" do
      Cranium.application.should be_a Cranium::Application
    end

    it "should return a singleton" do
      Cranium.application.should equal Cranium.application
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

      Cranium.configuration.greenplum_connection_string.should == "new greenplum connection"
      Cranium.configuration.mysql_connection_string.should == "mysql connection"
    end
  end


  describe ".configuration" do
    it "should return the configuration" do
      Cranium.configuration.should be_a Cranium::Configuration
    end

    it "should not let the user modify the configuration" do
      expect { Cranium.configuration.greenplum_connection_string = "constring" }.to raise_error
    end
  end

end
