Feature: Import a CSV file into the database with merging

  The merge_on property can be used to specify an id field that is used to detect duplicates while importing.
  Duplicates are updated and new items are added.

  Scenario: Successful import with merged items
    Given a database table called "lkp_categories" with the following fields:
      | field_name  | field_type |
      | contact_id  | INTEGER    |
      | category_id | TEXT       |
    And only the following rows in the "lkp_categories" database table:
      | contact_id (i) | category_id (s) |
      | 1              | A               |
      | 1              | B               |
      | 1              | C               |
      | 2              | A               |
      | 2              | D               |
    And a "category_lookup.csv" data file containing:
    """
    user_id,category_id
    1,A
    1,E
    3,E
    3,F
    """
    And the following definition:
    """
    source :category_lookup do
      field :user_id, Integer
      field :category_id, String
    end

    import :category_lookup do
      into :lkp_categories

      put :user_id => :contact_id
      put :category_id => :category_id

      delete_insert_on :contact_id
    end
    """
    When I execute the definition
    Then the process should be successful
    And the "lkp_categories" table should contain:
      | contact_id (i) | category_id (s) |
      | 1              | A               |
      | 1              | E               |
      | 2              | A               |
      | 2              | D               |
      | 3              | E               |
      | 3              | F               |