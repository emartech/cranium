require 'tmpdir'
require_relative "../../lib/cranium"

unless ENV["STOP_ON_FIRST_ERROR"] == "no"
  After do |scenario|
    Cucumber.wants_to_quit = true if scenario.failed?
  end
end


World do
  Cranium::TestFramework::World.new
end


Around do |_, block|
  Dir.mktmpdir do |dir|
    Dir.chdir dir
    block.call
  end
end
