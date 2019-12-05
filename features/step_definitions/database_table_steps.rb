Given(/^a database table called "([^"]*)" with the following fields:$/) do |table_name, fields|
  database_table(table_name).create(fields.data)
end


Given(/^only the following rows in the "([^"]*)" database table:$/) do |table_name, rows|
  database_table(table_name).clear
  step %Q(the following new rows in the "#{table_name}" database table:), rows
end


Given(/^the following new rows in the "([^"]*)" database table:$/) do |table_name, rows|
  database_table(table_name).insert rows.data
end


Given(/^the current value in sequence "([^"]*)" is (\d+)$/) do |sequence_name, current_value|
  Cranium::Database.connection.run "SELECT setval('#{sequence_name}', #{current_value})"
end


Given(/^a sequence called "([^"]*)" starting from (\d+)$/) do |sequence_name, start_value|
  database_sequence(sequence_name).create

  step %Q[the current value in sequence "#{sequence_name}" is #{start_value}]
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

  expect(database_table(table_name).content(data.fields)).to match_array expected_data
end


Then(/^the "([^"]*)" table should contain ([\d_]+) .+$/) do |table_name, count|
  expect(database_table(table_name).count).to eq count.to_i
end
