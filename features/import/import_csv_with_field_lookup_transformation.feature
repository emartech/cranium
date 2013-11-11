Feature: Import a CSV file into the database with IDs looked up from the database

  Scenario: Successful import
    Given a database table called "dim_contact" with the following fields:
      | field_name  | field_type |
      | contact_key | SERIAL     |
      | user_id     | TEXT       |
      | name        | TEXT       |
    And only the following rows in the "dim_contact" database table:
      | contact_key (i) | user_id | name  |
      | 10              | 1       | Alma  |
      | 20              | 2       | Korte |
    And a database table called "fct_purchases" with the following fields:
      | field_name  | field_type |
      | contact_key | INTEGER    |
      | amount      | TEXT       |
    And a "purchases.csv" data file containing:
    """
    user_id,amount
    1,100
    2,200
    3,300
    """
    And the following definition:
    """
    source :purchases do
      field :user_id, String
      field :amount, String
    end

    source :transformed_purchases do
      field :contact_key, Integer
      field :amount, String
    end

    transform :purchases => :transformed_purchases do |record|
      record[:contact_key] = lookup :contact_key,
                                    from_table: :dim_contact,
                                    match_column: :user_id,
                                    to_value: record[:user_id],
                                    if_not_found_then: -1
    end

    import :transformed_purchases do
      into :fct_purchases
      put :contact_key => :contact_key
      put :amount => :amount
    end
    """
    When I execute the definition
    Then the "fct_purchases" table should contain:
      | contact_key (i) | amount |
      | 10              | 100    |
      | 20              | 200    |
      | -1              | 300    |


  Scenario: Multiple fields looked up by one key
    Given a database table called "dim_contact" with the following fields:
      | field_name    | field_type |
      | contact_key_1 | INTEGER    |
      | contact_key_2 | INTEGER    |
      | user_id       | TEXT       |
      | name          | TEXT       |
    And only the following rows in the "dim_contact" database table:
      | contact_key_1 (i) | contact_key_2 (i) | user_id | name  |
      | 10                | 100               | 1       | Alma  |
      | 20                | 200               | 2       | Korte |
    And a database table called "fct_purchases" with the following fields:
      | field_name    | field_type |
      | contact_key_1 | INTEGER    |
      | contact_key_2 | INTEGER    |
      | amount        | TEXT       |
    And a "purchases.csv" data file containing:
    """
    user_id,amount
    1,100
    2,200
    3,300
    """
    And the following definition:
    """
    source :purchases do
      field :user_id, String
      field :amount, String
    end

    source :transformed_purchases do
      field :contact_key_1, Integer
      field :contact_key_2, Integer
      field :amount, String
    end

    transform :purchases => :transformed_purchases do |record|
      record[:contact_key_1] = lookup :contact_key_1,
                                    from_table: :dim_contact,
                                    match_column: :user_id,
                                    to_value: record[:user_id],
                                    if_not_found_then: -1

      record[:contact_key_2] = lookup :contact_key_2,
                                    from_table: :dim_contact,
                                    match_column: :user_id,
                                    to_value: record[:user_id],
                                    if_not_found_then: -2
    end

    import :transformed_purchases do
      into :fct_purchases
      put :contact_key_1 => :contact_key_1
      put :contact_key_2 => :contact_key_2
      put :amount => :amount
    end
    """
    When I execute the definition
    Then the "fct_purchases" table should contain:
      | contact_key_1 (i) | contact_key_2 (i) | amount |
      | 10                | 100               | 100    |
      | 20                | 200               | 200    |
      | -1                | -2                | 300    |