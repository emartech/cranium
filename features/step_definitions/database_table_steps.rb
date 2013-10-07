Given(/^a database table called "([^"]*)" with the following fields:$/) do |table_name, fields|
  database_table(table_name.to_sym).create(fields.data)
end

Given (/^only the following rows in the "([^"]*)" database table:$/) do |table_name, table|
  database_table(table_name.to_sym).insert table.data
end


Then(/^the "([^"]*)" table should contain:$/) do |table_name, data|
  expected_data, hashes = [], data.data
  hashes.map do |hash|
    new_row = {}
    hash.each_key do |key|
      new_row[key.to_sym] = hash[key]
    end
    expected_data << new_row
  end

  database_table(table_name.to_sym).content(data.fields).should =~ expected_data
end

