require_relative '../spec_helper'

describe Cranium::CommandLineOptions do

  let(:argv) {
    %w[
      --cranium-initializer my_initializer
      --cranium-load my_load
      --some-param some_value
      --another-param another_value
    ]
  }


  subject { Cranium::CommandLineOptions.new argv }

  describe "#cranium_arguments" do

    it "should return only arguments used by Cranium" do
      expect(subject.cranium_arguments).to eq(initializer: "my_initializer", load: "my_load")
    end

  end


  describe "#load_arguments" do
    it "should return non-cranium arguments" do
      expect(subject.load_arguments).to eq(:"some-param" => "some_value", :"another-param" => "another_value")
    end
  end

end
