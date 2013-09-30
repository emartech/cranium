unless ENV["STOP_ON_FIRST_ERROR"] == "no"
  After do |scenario|
    Cucumber.wants_to_quit = true if scenario.failed?
  end
end
