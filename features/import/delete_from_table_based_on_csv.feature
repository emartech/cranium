Feature: Delete rows from table provided by CSV file

  Scenario: Successful delete
    Given a database table called "dim_contact" with the following fields:
      | field_name  | field_type |
      | source_id   | TEXT       |
    And only the following rows in the "dim_contact" database table:
      | source_id (i) |
      | 1             |
      | 2             |
      | 3             |
      | 4             |
      | 5             |
    And a "deleted_contacts_extract.csv" data file containing:
    """
    source_id
    3
    4
    """
    And the following definition:
    """
    source :deleted_contacts_extract do
      field :source_id, String
    end

    import :deleted_contacts_extract do
      into :dim_contact
      put :source_id

      delete_on :source_id
    end
    """
    When I execute the definition
    Then the process should exit successfully
    And the "dim_contact" table should contain:
      | source_id   |
      | 1           |
      | 2           |
      | 5           |
