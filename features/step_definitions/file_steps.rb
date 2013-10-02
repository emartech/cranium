When(/^a "([^"]*)" data file containing:$/) do |file_name, content|
  file_system.save_file file_name, content
end


Then(/^there is a "([^"]*)" data file containing:$/) do |file_name, content|
  file_system.file_exists?(file_name).should be_true, "expected #{file_name} to exist"
  file_system.read_file(file_name).chomp.should == content
end
