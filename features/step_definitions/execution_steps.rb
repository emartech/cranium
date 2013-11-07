Given(/^the definition is executed$/) do
  step "I execute the definition"
end


When(/^I execute the definition(?: again)?$/) do
  execute_definition
end


Then(/the process should be successful/) do
  result_code.should eq(0), "The process should have been successful"
end
