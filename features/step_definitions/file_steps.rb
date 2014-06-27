Given /^no "([^"]*)" directory/ do |dir_path|
  upload_directory.remove_directory dir_path
end


Given /^an empty "([^"]*)" data file$/ do |file_name|
  step %Q(a "#{file_name}" data file containing:), ""
end


Given /^an? "([^"]*)" data file containing:$/ do |file_name, content|
  upload_directory.save_file file_name, content
end


Given /^the "([^"]*)" file is deleted$/ do |file_name|
  upload_directory.delete_file file_name
end


Then /^there should be a "([^"]*)" data file in the upload directory containing:$/ do |file_name, content|
  upload_directory.file_exists?(file_name).should be_truthy, "expected file '#{file_name}' to exist"
  upload_directory.read_file(file_name).chomp.should == content
end


Then /^the "([^"]*)" directory should contain the following files:$/ do |directory_path, files|
  Dir.exists?(directory_path).should be_truthy, "expected directory '#{directory_path}' to exist"
  files_in_dir = Dir["#{directory_path}/*"].map { |file_name| File.basename file_name }.sort
  files_in_dir.count.should == files.data.count
  0.upto files.data.count-1 do |index|
    files_in_dir[index].should =~ Regexp.new(files.data[index][:filename])
  end
end


Then /^the upload directory should contain the following files:$/ do |files|
  step %Q(the "#{Cranium.configuration.upload_path}" directory should contain the following files:), files
end
