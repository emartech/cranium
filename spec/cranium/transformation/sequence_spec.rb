require_relative '../../spec_helper'

describe Cranium::Transformation::Sequence do

  def stub_next_value(value)
    dataset = double "dataset"
    allow(dataset).to receive_messages first: { next_value: value }
    allow(Cranium::Database).to receive_message_chain(:connection, :[]).with("SELECT nextval('id_seq') AS next_value").and_return(dataset)
  end



  let(:sequence) { Cranium::Transformation::Sequence.new :id_seq }

  describe ".by_name" do
    before(:each) { Cranium::Transformation::Sequence.instance_variable_set :@sequences, nil }

    it "should return a sequence with the specified name" do
      sequence = Cranium::Transformation::Sequence.by_name(:id_seq)

      expect(sequence).to be_a Cranium::Transformation::Sequence
      expect(sequence.name).to eq(:id_seq)
    end

    it "should schedule a newly created sequence's flush method as an after_import hook" do
      expect(Cranium.application).to receive(:after_import).once

      Cranium::Transformation::Sequence.by_name(:id_seq)
      Cranium::Transformation::Sequence.by_name(:id_seq)
    end

    it "should memoize previously created instances" do
      expect(Cranium::Transformation::Sequence.by_name(:id_seq)).to equal Cranium::Transformation::Sequence.by_name(:id_seq)
    end
  end


  describe "#next_value" do
    before(:each) do
      stub_next_value 123
    end

    context "the first time it's called" do
      it "should return the named sequence's next value read from the database" do
        expect(sequence.next_value).to eq(123)
      end
    end

    context "on subsequent calls" do
      it "should increment its counter internally without querying the database" do
        expect(sequence.next_value).to eq(123)

        expect(Cranium::Database).not_to receive :connection

        expect(sequence.next_value).to eq(124)
        expect(sequence.next_value).to eq(125)
      end
    end
  end


  describe "#flush" do
    let(:sequence) { Cranium::Transformation::Sequence.new :id_seq }

    it "should not use the database if no value was ever requested from the sequence" do
      expect(Cranium::Database).not_to receive :connection

      sequence.flush
    end

    it "should set the database sequence's value to the last value returned" do
      stub_next_value 123
      sequence.next_value

      connection = double "connection"
      allow(Cranium::Database).to receive_messages connection: connection
      expect(connection).to receive(:run).with("SELECT setval('id_seq', 123)")

      sequence.flush
    end
  end

end
