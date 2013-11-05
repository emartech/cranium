require_relative 'config'

extract :contacts do
  from :suite
  incrementally_by :created
  query <<-sql
    SELECT *
    FROM contacts
    WHERE created BETWEEN '#{last_extracted_value_of :created, "1970-01-01 00:00:00"}' AND '#{Time.now - 60*10}'
  sql
end

extract :contacts do
  from :suite
  incrementally_by :id
  query "SELECT * FROM akarmi WHERE id > #{last_extracted_value_of :id, 0}"
end
