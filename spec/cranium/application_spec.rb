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
      expect(application.respond_to?(:log)).to be_truthy
    end
  end


  describe "#sources" do
    it "should return a SourceRegistry" do
      expect(application.sources).to be_a Cranium::SourceRegistry
    end
  end


  describe "#register_source" do
    it "should register a source in the source registry and resolve its files" do
      source = double "SourceDefinition"

      expect(application.sources).to receive(:register_source).with(:source1).and_return(source)
      expect(source).to receive(:resolve_files)

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
        expect { application.run }.to raise_error(SystemExit) { |exit| expect(exit.status).to eq(1) }
      end

      it "should log an error to STDOUT" do
        expect { application.run }.to raise_error

        expect($stderr.string.chomp).to eq "ERROR: No file specified"
      end
    end


    context "when a non-existent file is specified as an argument" do
      let(:application) { Cranium::Application.new ["--cranium-load", "no-such-file.exists"] }

      it "should exit with an error" do
        expect { application.run }.to raise_error(SystemExit) { |exit| expect(exit.status).to eq(1) }
      end

      it "should log an error to STDOUT" do
        expect { application.run }.to raise_error

        expect($stderr.string.chomp).to eq "ERROR: File 'no-such-file.exists' does not exist"
      end
    end


    context "when called with an existing file" do
      let(:file) { "products.rb" }

      let(:application) { Cranium::Application.new ["--cranium-load", file] }

      before(:each) do
        allow(File).to receive(:exists?).with(file).and_return(true)
      end


      it "should load the first file specified as a command line parameter" do
        expect(application).to receive(:load).with(file)

        application.run
      end


      it "should run any registered after hooks" do
        allow(application).to receive :load

        hook_ran = false
        application.register_hook :after do
          hook_ran = true
        end

        application.run

        expect(hook_ran).to be_truthy
      end


      context "when the execution of the process raises an error" do
        let(:error) { StandardError.new }
        before(:each) { allow(application).to receive(:load).and_raise error }

        it "should propagate the error" do
          expect { application.run }.to raise_error
        end

        it "should log an error" do
          expect(application).to receive(:log).with(:error, error)

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

          expect(hook_ran).to be_truthy
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

      expect(block_called).to be_truthy
    end

  end

end
