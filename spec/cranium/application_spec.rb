require_relative '../spec_helper'

describe Cranium::Application do

  let(:application) { Cranium::Application.new [] }


  describe "#load_arguments" do
    it "should return the provided load arguments" do
      app = Cranium::Application.new ["--cranium-load", "load", "--customer_name", "my_customer"]
      expect(app.load_arguments).to eq customer_name: "my_customer"
    end
  end

  describe "#cranium_arguments" do
    it "should return the provided load arguments" do
      app = Cranium::Application.new ["--cranium-load", "loads/load_file", "--customer_name", "my_customer"]
      expect(app.cranium_arguments).to eq load: "loads/load_file"
    end
  end


  describe "Application" do
    it "should include metrics logging capabilities" do
      application.respond_to?(:log).should be_truthy
    end
  end


  describe "#sources" do
    it "should return a SourceRegistry" do
      application.sources.should be_a Cranium::SourceRegistry
    end
  end


  describe "#register_source" do
    it "should register a source in the source registry and resolve its files" do
      source = double "SourceDefinition"

      application.sources.should_receive(:register_source).with(:source1).and_return(source)
      source.should_receive :resolve_files

      application.register_source(:source1) { file "test*.csv" }
    end
  end


  describe "#run" do
    before(:each) do
      @original_stderr = $stderr
      $stderr = StringIO.new
    end

    after(:each) do
      $stderr = @original_stderr
    end

    context "when no files are specified as an argument" do
      it "should exit with an error" do
        expect { application.run }.to raise_error(SystemExit) { |exit| exit.status.should == 1 }
      end

      it "should log an error to STDOUT" do
        expect { application.run }.to raise_error

        $stderr.string.chomp.should == "ERROR: No file specified"
      end
    end


    context "when a non-existent file is specified as an argument" do
      let(:application) { Cranium::Application.new ["--cranium-load", "no-such-file.exists"] }

      it "should exit with an error" do
        expect { application.run }.to raise_error(SystemExit) { |exit| exit.status.should == 1 }
      end

      it "should log an error to STDOUT" do
        expect { application.run }.to raise_error

        $stderr.string.chomp.should == "ERROR: File 'no-such-file.exists' does not exist"
      end
    end


    context "when called with an existing file" do
      let(:file) { "products.rb" }

      let(:application) { Cranium::Application.new ["--cranium-load", file] }

      before(:each) do
        File.stub(:exists?).with(file).and_return(true)
      end


      it "should load the first file specified as a command line parameter" do
        application.should_receive(:load).with(file)

        application.run
      end


      it "should run any registered after hooks" do
        application.stub(:load)

        hook_ran = false
        application.register_hook :after do
          hook_ran = true
        end

        application.run

        hook_ran.should be_truthy
      end


      context "when the execution of the process raises an error" do
        let(:error) { StandardError.new }
        before(:each) { application.stub(:load).and_raise error }

        it "should propagate the error" do
          expect { application.run }.to raise_error
        end

        it "should log an error" do
          application.as_null_object
          application.should_receive(:log).with(:error, error)

          expect { application.run }.to raise_error
        end

        it "should still run any registered after hooks" do
          hook_ran = false
          application.register_hook :after do
            hook_ran = true
          end

          begin
            application.run
          rescue
          end

          hook_ran.should be_truthy
        end
      end
    end
  end


  describe "#after_import" do

    it "should register the given block" do
      block_called = false

      application.after_import do
        block_called = true
      end

      application.apply_hook(:after_import)

      block_called.should be_truthy
    end

  end

end
