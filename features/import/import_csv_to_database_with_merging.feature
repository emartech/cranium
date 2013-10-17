Feature: Import a CSV file into the database with merging

  The merge_on property can be used to specify an id field that is used to detect duplicates while importing.
  Duplicates are updated and new items are added.

  Scenario: Successful import with merged items
    Given a database table called "dim_product" with the following fields:
      | field_name  | field_type |
      | item        | TEXT       |
      | title       | TEXT       |
      | description | TEXT       |
    And only the following rows in the "dim_product" database table:
      | item    | title                | description                  |
      | JNI-123 | Just a product name  | Very interesting description |
      | CDI-234 | Another product name | Yet another cool description |
    And a "products.csv" data file containing:
    """
    id,name,description
    JNI-123,Just a product name,"Very interesting description, updated"
    CDI-234,Updated product name,Yet another cool description
    KLM-987,Inserted product name,This is the best product
    """
    And the following definition:
    """
    source :products do
      field :id, String
      field :name, String
      field :description, String
    end

    import :products do
      into :dim_product
      put :id => :item
      put :name => :title
      put :description => :description

      merge_on :id => :item
    end
    """
    When I execute the definition
    Then the "dim_product" table should contain:
      | item    | title                 | description                           |
      | JNI-123 | Just a product name   | Very interesting description, updated |
      | CDI-234 | Updated product name  | Yet another cool description          |
      | KLM-987 | Inserted product name | This is the best product              |
