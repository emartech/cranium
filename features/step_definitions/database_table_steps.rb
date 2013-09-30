Given(/^a database table called "([^"]*)" with the following fields:$/) do |table_name, fields|
  database_table(table_name.to_sym).create(fields.hashes)
end


Then(/^the "([^"]*)" table should contain:$/) do |table_name, data|
  headers = data.headers.map { |field| field.to_sym }
  database_table(table_name.to_sym).content(headers).should =~ data.hashes
end
