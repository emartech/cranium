require_relative '../spec_helper'
require 'ostruct'

describe Cranium::ExternalTable do

  let(:connection) { double "Greenplum connection" }
  let(:source) do
    Cranium::Source.new(:products).tap do |source|
      source.file "test_products.csv"
      source.field :text_field, String
      source.field :integer_field, Integer
      source.field :numeric_field, Fixnum
      source.field :date_field, Date
      source.field :timestamp_field, Time
      source.delimiter ';'
      source.quote '"'
      source.escape "'"
    end
  end
  let(:external_table) { Cranium::ExternalTable.new source, connection }


  describe "#create" do
    it "should create an external table from the specified source" do
      Cranium.stub :configuration => OpenStruct.new(
        :gpfdist_url => "gpfdist-url",
        :gpfdist_home_directory => "/gpfdist-home",
        :upload_directory => "upload-dir"
      )

      connection.should_receive(:run).with(<<-sql
      CREATE EXTERNAL TABLE "external_products" (
          text_field TEXT,
          integer_field INTEGER,
          numeric_field NUMERIC,
          date_field DATE,
          timestamp_field TIMESTAMP WITHOUT TIME ZONE
      )
      LOCATION ('gpfdist://gpfdist-url/gpfdist-home/test_products.csv')
      FORMAT 'CSV' (DELIMITER ';' ESCAPE '''' QUOTE '"' HEADER)
      ENCODING 'UTF8'
      sql
      )

      external_table.create
    end
  end


  describe "#destroy" do
    it "should drop the external table" do
      connection.should_receive(:run).with(%Q[DROP EXTERNAL TABLE "products"])

      external_table.destroy
    end
  end

end
