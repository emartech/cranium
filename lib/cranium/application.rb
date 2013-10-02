class Cranium::Application

  include Cranium::Logging

  attr_reader :sources



  def initialize
    @sources = Cranium::SourceRegistry.new
  end



  def register_source(name, &block)
    @sources.register_source name, &block
  end



  def run(args)
    exit 1 if args.empty?

    start_time = Time.now
    begin
      load args.first
    ensure
      record_timer process_name(args.first), start_time, Time.now
    end
  end



  private

  def process_name(file_name)
    File.basename(file_name, File.extname(file_name))
  end

end
