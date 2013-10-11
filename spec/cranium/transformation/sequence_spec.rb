require_relative '../../spec_helper'

describe Cranium::Transformation::Sequence do

  def stub_next_value(value)
    dataset = double "dataset"
    dataset.stub first: { next_value: value }
    Cranium::Database.stub_chain(:connection, :[]).with("SELECT nextval('id_seq') AS next_value").and_return(dataset)
  end



  let(:sequence) { Cranium::Transformation::Sequence.new :id_seq }

  describe ".by_name" do
    before(:each) { Cranium::Transformation::Sequence.instance_variable_set :@sequences, nil }

    it "should return a sequence with the specified name" do
      sequence = Cranium::Transformation::Sequence.by_name(:id_seq)

      sequence.should be_a Cranium::Transformation::Sequence
      sequence.name.should == :id_seq
    end

    it "should schedule a newly created sequence's flush method as an after_import hook" do
      Cranium.application.should_receive(:after_import).once

      Cranium::Transformation::Sequence.by_name(:id_seq)
      Cranium::Transformation::Sequence.by_name(:id_seq)
    end

    it "should memoize previously created instances" do
      Cranium::Transformation::Sequence.by_name(:id_seq).should equal Cranium::Transformation::Sequence.by_name(:id_seq)
    end
  end


  describe "#next_value" do
    before(:each) do
      stub_next_value 123
    end

    context "the first time it's called" do
      it "should return the named sequence's next value read from the database" do
        sequence.next_value.should == 123
      end
    end

    context "on subsequent calls" do
      it "should increment its counter internally without querying the database" do
        sequence.next_value.should == 123

        Cranium::Database.should_not_receive :connection

        sequence.next_value.should == 124
        sequence.next_value.should == 125
      end
    end
  end


  describe "#flush" do
    let(:sequence) { Cranium::Transformation::Sequence.new :id_seq }

    it "should not use the database if no value was ever requested from the sequence" do
      Cranium::Database.should_not_receive :connection

      sequence.flush
    end

    it "should set the database sequence's value to the last value returned" do
      stub_next_value 123
      sequence.next_value

      connection = double "connection"
      Cranium::Database.stub connection: connection
      connection.should_receive(:run).with("SELECT setval('id_seq', 123)")

      sequence.flush
    end
  end

end
