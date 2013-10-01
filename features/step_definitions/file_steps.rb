When(/^a "([^"]*)" data file containing:$/) do |file_name, content|
  save_file file_name, content
end
