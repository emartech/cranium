Feature: Extracting data incrementally from a database table to CSV

  Incremental extracts work by indicating that a field (or fields) should be used to detect new data rows
  in the table. The highest extracted values are saved from one process and passed on to the next when the
  process is run again. This approach typically works best with id or timestamp fields.


  Scenario: Successful extract
    Given the following definition:
    """
    database :suite do
      connect_to Cranium.configuration.greenplum_connection_string
    end

    extract :contacts do
      from :suite
      incrementally_by :id
      query "SELECT id, name FROM contacts WHERE id > #{last_extracted_value_of :id, 0} ORDER BY id DESC"
    end
    """
    And a database table called "contacts" with the following fields:
      | field_name | field_type |
      | id         | INTEGER    |
      | name       | TEXT       |
    And only the following rows in the "contacts" database table:
      | id | name       |
      | 1  | John Doe   |
      | 2  | Jane Doe   |
    And the definition is executed
    And the following new rows in the "contacts" database table:
      | id | name       |
      | 3  | John Smith |
      | 4  | Jane Smith |
    When I execute the definition again
    Then the process should be successful
    And there should be a "contacts.csv" data file in the upload directory containing:
    """
    id,name
    4,Jane Smith
    3,John Smith
    """
