require_relative '../spec_helper'

describe Cranium::Application do

  let(:application) { Cranium::Application.new }

  describe "#sources" do
    it "should return a SourceRegistry" do
      application.sources.should be_a Cranium::SourceRegistry
    end
  end


  describe "#register_source" do
    it "should register a source in the source registry" do
      block_called = false
      application.register_source(:source1) { block_called = true }

      application.sources[:source1].should_not be_nil
      block_called.should be_true
    end
  end


  describe "#run" do
    it "should exit with an error if no file was specified as a command line argument" do
      expect { application.run [] }.to raise_error(SystemExit) { |exit| exit.status.should == 1 }
    end


    it "should load the first file specified as a command line parameter" do
      application.should_receive(:load).with("definition1.rb")
      application.should_not_receive(:load).with("definition2.rb")

      application.run ["definition1.rb", "definition2.rb"]
    end
  end

end
