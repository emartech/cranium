require_relative '../spec_helper'

describe Cranium::Logging do

  let(:logging_object) { Object.new.tap { |object| object.extend Cranium::Logging } }
  let(:loggers) { [double("Logger 1"), double("Logger 2")] }

  before(:each) do
    Cranium.stub_chain(:configuration, :loggers).and_return loggers
  end



  def all_loggers_should_receive(level, message)
    loggers.each { |logger| logger.should_receive(level).with(message) }
  end



  describe "#record_metric" do
    it "should record an arbitrary metric in every registered logger" do
      all_loggers_should_receive :info, "[metrics/products] 1234"

      logging_object.record_metric "products", 1234
    end
  end


  describe "record_timer" do
    it "should record a time-type metric in every registered logger" do
      all_loggers_should_receive :info, "[metrics/products] 1.234s"

      logging_object.record_timer "products", 0, 1.234
    end
  end


  describe "#log" do
    it "should log a message with the specified reporting level in every registered logger" do
      all_loggers_should_receive :error, "error message"

      logging_object.log :error, "error message"
    end
  end

end
