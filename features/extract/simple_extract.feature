Feature: Extracting data from a database table to CSV

  Data can be extracted from a database table into a CSV file. The CSV file is named after the extract process
  and is placed in the upload directory specified in the configuration.


  Scenario: Successful extract using raw SQL
    Given a database table called "contacts" with the following fields:
      | field_name | field_type |
      | id         | INTEGER    |
      | name       | TEXT       |
    And only the following rows in the "contacts" database table:
      | id | name       |
      | 1  | John Doe   |
      | 2  | Jane Doe   |
      | 3  | John Smith |
    And the following definition:
    """
    database :suite do
      connect_to Cranium.configuration.greenplum_connection_string
    end

    extract :contacts do
      from :suite
      query "SELECT id, name FROM contacts WHERE name LIKE '%Doe%' ORDER BY id"
    end
    """
    When I execute the definition
    Then the process should be successful
    And there should be a "contacts.csv" data file in the upload directory containing:
    """
    id,name
    1,John Doe
    2,Jane Doe
    """
