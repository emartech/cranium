Given(/^a database table called "([^"]*)" with the following fields:$/) do |table_name, fields|
  database_table(table_name.to_sym).create(fields.hashes)
end

Given (/^only the following rows in the "([^"]*)" database table:$/) do |table_name, table|
  database_table(table_name.to_sym).insert table.hashes
end


Then(/^the "([^"]*)" table should contain:$/) do |table_name, data|
  headers = data.headers.map { |field| field.to_sym }

  expected_data, hashes = [], data.hashes
  hashes.map do |hash|
    new_row = {}
    hash.each_key do |key|
      new_row[key.to_sym] = hash[key]
    end
    expected_data << new_row
  end

  database_table(table_name.to_sym).content(headers).should =~ expected_data
end

