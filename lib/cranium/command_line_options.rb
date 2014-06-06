require "slop"

class Cranium::CommandLineOptions

  def initialize(arguments)
    @arguments = Slop.parse(arguments, autocreate: true).to_hash
  end



  def cranium_arguments
    @cranium_arguments ||= Hash[arguments.map { |k, v| [$1.to_sym, v] if k.to_s =~ /\Acranium\-(.*)/ }.compact]
  end



  def load_arguments
    @load_arguments ||= Hash[arguments.map { |k, v| [k, v] unless k.to_s =~ /\Acranium\-(.*)/ }.compact]
  end



  private

  attr_reader :arguments

end