require_relative '../spec_helper'

describe Cranium::FileUtils do

  describe '#line_count' do
    let(:path) { '/tmp/3_lines.txt' }
    let(:number_of_lines) { 3 }

    before do
      File.open(path, 'w') do |file|
        number_of_lines.times { |i| file.puts i }
      end
    end

    after { File.delete path }

    it 'returns the number of lines the file has' do
      expect(described_class.line_count(path)).to eq(number_of_lines)
    end
  end

end
