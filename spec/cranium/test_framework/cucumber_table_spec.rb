require_relative "../../spec_helper"
require 'cucumber/ast/table'
require 'date'

module Cranium::TestFramework
  describe CucumberTable do

    context "class method" do
      describe ".from_cucumber_table" do

        let(:table) { CucumberTable.from_ast_table(Cucumber::Ast::Table.new(@table_data)) }

        it "should return a CucumberTable" do
          @table_data = [{ "column" => "value" }]

          table.should be_a CucumberTable
        end


        it "should convert header values to symbols" do
          @table_data = [{ "column1" => "value1", "column2" => "value2" }]

          table.fields.should == [:column1, :column2]
        end


        it "should discard comment columns" do
          @table_data = [{ "column" => "value1", "#comment column" => "value2" }]
          CucumberTable.should_receive(:new).with([{ column: "value1" }], { column: :string })

          table
        end


        it "should discard type specifiers in column names" do
          @table_data = [{
                           "integer_column (i)" => "one",
                           "string_column (s)" => "two",
                           "numeric_column (n)" => "five",
                           "some_column" => "else"
                         }]

          table.fields.should =~ [:integer_column, :string_column, :numeric_column, :some_column]
        end


        it "should raise an exception if invalid type is specified" do
          @table_data = [{ "column (x)" => "value" }]

          expect { table.fields }.to raise_error StandardError, "Invalid type specified: x"
        end


        it "should instantiate the new table with the correct column types" do
          @table_data = [{
                           "integer_column (i)" => "one",
                           "string_column (s)" => "two",
                           "numeric_column (n)" => "five",
                           "some_column" => "else"
                         }]
          CucumberTable.should_receive(:new).with(
            [{
               integer_column: "one",
               string_column: "two",
               numeric_column: "five",
               some_column: "else"
             }],
            {
              integer_column: :integer,
              string_column: :string,
              numeric_column: :numeric,
              some_column: :string
            }
          )

          table
        end
      end
    end


    context "instance methods" do
      let(:data) { [{ "one" => "two", "three" => "four" }, { "five" => "six" }] }

      describe "#fields" do
        it "should return the keys of the first row" do
          CucumberTable.new(data).fields.should == %w[one three]
        end
      end


      describe "#with_patterns" do
        it "should set replacement patterns and return the object" do
          table = CucumberTable.new(data)
          table_with_patterns = table.with_patterns({ "a" => "b" })

          table_with_patterns.should be_equal table
        end
      end


      describe "#data" do
        it "should return all data as an array of hashes" do
          CucumberTable.new(data).data.should == data
        end


        it "should make all substitutions set up as replacement patterns" do
          table = CucumberTable.new [{ first: "NULL", second: "apple", third: "something else entirely" }]
          table.with_patterns(
            "NULL" => nil,
            "apple" => lambda { "pear" }
          )

          table.data.should == [first: nil, second: "pear", third: "something else entirely"]
        end


        it "should evaluate integer fields" do
          table = CucumberTable.new([{ integer_column: "20" }], { integer_column: :integer })
          table.data.should == [{ integer_column: 20 }]
        end


        describe "#columns" do
          it "should return an array of empty arrays if there are no data rows" do
            table = CucumberTable.new [], { argument: :string }

            table.data.columns.should == [[]]
          end


          it "should return the data in columns as an array of arrays, discarding all header information" do
            table = CucumberTable.new [{ header1: "value1", header2: "value2" }, { header1: "value3", header2: "value4" }]

            table.data.columns.should == [%w[value1 value3], %w[value2 value4]]
          end
        end
      end

    end

  end
end
