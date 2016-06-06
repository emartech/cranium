require_relative '../spec_helper'

describe Cranium::FileUtils do

  describe '#line_count' do
    let(:number_of_lines) { 3 }

    it 'returns the number of lines the file has' do
      path = '/tmp/3_lines.txt'
      create_test_file path, number_of_lines

      expect(described_class.line_count(path)).to eq(number_of_lines)
      File.delete path
    end

    it 'handles () characters in path' do
      path = '/tmp/such_copy_of_a_copy(2).txt'
      create_test_file path, number_of_lines

      expect { described_class.line_count(path) }.not_to raise_error
      File.delete path
    end
  end



  def create_test_file(path, number_of_lines)
    File.open(path, 'w') do |file|
      number_of_lines.times { |i| file.puts i }
    end
  end

end
