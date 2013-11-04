When(/^I execute the definition$/) do
  execute_definition
end


Then(/the process should be successful/) do
  result_code.should eq(0), "The process should have been successful"
end
