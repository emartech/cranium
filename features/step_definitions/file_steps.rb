When(/^a "([^"]*)" data file containing:$/) do |file_name, content|
  save_file file_name, content, File.join(Cranium.configuration.gpfdist_home_directory, Cranium.configuration.upload_directory)
end
