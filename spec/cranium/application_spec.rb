require_relative '../spec_helper'

describe Cranium::Application do

  let(:application) { Cranium::Application.new }

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
