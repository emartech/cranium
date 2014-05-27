Given /^the definition is executed$/ do
  step "I execute the definition"
end


When /^I execute the definition(?: again)?$/ do
  execute_definition
end


Then /^the process should exit successfully$/ do
  result_code.should eq(0), "Expected script exit code to be 0, but received #{result_code}\n\n#{script_output}\n"
end


Then /^the process should exit with an error$/ do
  result_code.should eq(1), "Expected script exit code to be 1, but received #{result_code}\n\n#{script_output}\n"
end


Then /^the error message should contain:$/ do |message|
  error_output.should include message
end
