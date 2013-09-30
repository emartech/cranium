class Cranium::Application

  def run(args)
    exit 1 if args.empty?

    load args.first
  end

end
