require_relative '../spec_helper'
require 'ostruct'

describe Cranium::ExternalTable do

  let(:connection) { double "Greenplum connection" }
  let(:source) do
    Cranium::DSL::SourceDefinition.new(:products).tap do |source|
      source.file "test_products.csv"
      source.field :text_field, String
      source.field :integer_field, Integer
      source.field :numeric_field, Float
      source.field :date_field, Date
      source.field :timestamp_field, Time
      source.field :boolean_field1, TrueClass
      source.field :boolean_field2, FalseClass
      source.delimiter ';'
      source.quote '"'
      source.escape "'"
    end
  end
  let(:external_table) { Cranium::ExternalTable.new source, connection }


  describe "#create" do
    it "should create an external table from the specified source" do
      Cranium.stub configuration: OpenStruct.new(
        gpfdist_url: "gpfdist-url",
        gpfdist_home_directory: "/gpfdist-home",
        upload_directory: "upload-dir"
      )

      source.stub files: %w(test_products_a.csv test_products_b.csv)

      connection.should_receive(:run).with(<<-sql
      CREATE EXTERNAL TABLE "external_products" (
          "text_field" TEXT,
          "integer_field" INTEGER,
          "numeric_field" NUMERIC,
          "date_field" DATE,
          "timestamp_field" TIMESTAMP WITHOUT TIME ZONE,
          "boolean_field1" BOOLEAN,
          "boolean_field2" BOOLEAN
      )
      LOCATION ('gpfdist://gpfdist-url/upload-dir/test_products_a.csv', 'gpfdist://gpfdist-url/upload-dir/test_products_b.csv')
      FORMAT 'CSV' (DELIMITER ';' ESCAPE '''' QUOTE '"' HEADER)
      ENCODING 'UTF8'
      sql
      )

      external_table.create
    end
  end


  describe "#destroy" do
    it "should drop the external table" do
      connection.should_receive(:run).with(%Q[DROP EXTERNAL TABLE "external_products"])

      external_table.destroy
    end
  end


  describe "#name" do
    it "should return the name of the external table based on the source's name" do
      external_table.name.should == :external_products
    end
  end

end
