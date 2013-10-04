BEGIN {
  require 'ruby-prof'
  RubyProf.start
}

END {
  profile = RubyProf.stop

  printer = RubyProf::CallStackPrinter.new profile
  profile_path = "/tmp/" + File.basename($0).gsub(".", "_") + "_profile.html"
  printer.print File.open(profile_path, "w"), min_percent: 1
  puts "Profiling information saved to: " + profile_path
}
