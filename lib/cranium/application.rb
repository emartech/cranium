class Cranium::Application

  include Cranium::Logging

  attr_reader :sources



  def initialize
    @sources = Cranium::SourceRegistry.new
    @hooks = {}
  end



  def register_source(name, &block)
    @sources.register_source(name, &block).resolve_files
  end



  def run(args)
    options = Cranium::CommandLineOptions.new args
    process_file = validate_file options.cranium_arguments[:load]

    log :info, "Process '#{process_name(process_file)}' started"

    begin
      load process_file
    rescue Exception => ex
      log :error, ex
      raise
    ensure
      log :info, "Process '#{process_name(process_file)}' finished"
    end
  end



  def after_import(&block)
    @hooks[:after_import] ||= []
    @hooks[:after_import] << block
  end



  def apply_hook(name)
    unless @hooks[name].nil?
      @hooks[name].each do |block|
        block.call
      end
    end
  end



  private

  def validate_file(load_file)
    exit_if_no_file_specified load_file
    exit_if_no_such_file_exists load_file
    load_file
  end



  def exit_if_no_file_specified(file)
    if file.nil? || file.empty?
      $stderr.puts "ERROR: No file specified"
      exit 1
    end
  end



  def exit_if_no_such_file_exists(file)
    unless File.exists? file
      $stderr.puts "ERROR: File '#{file}' does not exist"
      exit 1
    end
  end



  def process_name(file_name)
    File.basename(file_name, File.extname(file_name))
  end

end
