RSpec.describe Cranium::Archiver do
  subject(:archiver) { described_class }

  let(:configuration) do
    Cranium::Configuration.new.tap do |config|
      config.gpfdist_home_directory = "tmp"
      config.upload_directory = "upload_directory"
      config.archive_directory = "tmp/archive_directory"
    end
  end
  let(:file1) { "file.txt" }
  let(:file2) { "another_file.txt" }

  before do
    allow(Cranium).to receive_messages(configuration: configuration)

    FileUtils.mkdir_p(configuration.upload_path)
    FileUtils.touch(File.join(configuration.upload_path, file1))
    FileUtils.touch(File.join(configuration.upload_path, file2))
  end

  describe ".archive" do
    before { FileUtils.rm_rf configuration.archive_directory }

    context "when archive directory does not exist" do
      it "creates the archive directory" do
        archiver.archive file1, file2

        expect(File.exists?(configuration.archive_directory)).to eq true
      end
    end

    context "when there are some file in the upload directory" do
      it "moves files to the archive directory" do
        archiver.archive file1, file2

        expect(File.exist?(File.join(configuration.upload_path, file1))).to eq false
        expect(File.exist?(File.join(configuration.upload_path, file2))).to eq false
        expect(File.exist?(File.join(configuration.archive_directory, Dir.glob("*#{file1}")))).to eq true
        expect(File.exist?(File.join(configuration.archive_directory, Dir.glob("*#{file2}")))).to eq true
      end
    end
  end

  describe ".remove" do
    it "removes files from the upload directory" do
      archiver.remove file1, file2

      expect(File.exist?(File.join(configuration.archive_directory, Dir.glob("*#{file1}")))).to eq true
      expect(File.exist?(File.join(configuration.archive_directory, Dir.glob("*#{file2}")))).to eq true
    end
  end

  describe ".move" do
    let(:target_directory) { "tmp/target_directory" }

    it "creates given directory if it does not exist" do
      archiver.move(file1, file2, target_directory: target_directory)

      expect(File.exists?(target_directory)).to eq true
    end

    it "moves files from upload directory into a given directory" do
      archiver.move(file1, file2, target_directory: target_directory)

      expect(File.exist?(File.join(configuration.upload_path, file1))).to eq false
      expect(File.exist?(File.join(configuration.upload_path, file2))).to eq false
      expect(File.exist?(File.join(target_directory, file1))).to eq true
      expect(File.exist?(File.join(target_directory, file2))).to eq true
    end
  end
end
