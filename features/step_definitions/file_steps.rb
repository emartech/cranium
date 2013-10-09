Given(/^no "([^"]*)" directory/) do |dir_path|
  upload_directory.remove_directory dir_path
end



When(/^a "([^"]*)" data file containing:$/) do |file_name, content|
  upload_directory.save_file file_name, content
end



Then(/^there is a "([^"]*)" data file in the upload directory containing:$/) do |file_name, content|
  upload_directory.file_exists?(file_name).should be_true, "expected #{file_name} to exist"
  upload_directory.read_file(file_name).chomp.should == content
end



Then(/^there is a "([^"]*)" data file containing:$/) do |file_name, content|
  File.exists?(file_name).should be_true, "expected #{file_name} to exist"
  File.read(file_name).chomp.should == content
end
