@wip
Feature: Import a CSV file into the database with merging

  The merge_on property can be used to specify an id field that is used to detect duplicates while importing.
  Duplicates are updated and new items are added.

  Scenario: Successful import with merged items
    Given a database table called "lkp_categories" with the following fields:
      | field_name  | field_type |
      | contact_id  | INTEGER    |
      | category_id | STRING     |
    And only the following rows in the "dim_product" database table:
      | contact_id (i) | category_id (s) |
      | 1              | A               |
      | 1              | B               |
      | 1              | C               |
      | 2              | A               |
      | 2              | D               |
    And a "products.csv" data file containing:
    """
    contact_id,category_id
    1,A
    1,E
    3,E
    3,F
    """
    And the following definition:
    """
    source :category_lookup do
      field :contact_id, Integer
      field :category_id, String
    end

    import :products do
      into :lkp_categories
      put :contact_id => :contact_id
      put :category_id => :category_id

      delete_on :id => :contact_id
    end
    """
    When I execute the definition
    Then the "lkp_categories" table should contain:
      | contact_id (i) | category_id (s) |
      | 1              | A               |
      | 1              | E               |
      | 2              | A               |
      | 2              | D               |
      | 3              | E               |
      | 3              | F               |