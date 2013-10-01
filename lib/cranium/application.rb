class Cranium::Application

  attr_reader :sources



  def initialize
    @sources = Cranium::SourceRegistry.new
  end



  def register_source(name, &block)
    @sources.register_source name, &block
  end



  def run(args)
    exit 1 if args.empty?

    load args.first
  end

end
