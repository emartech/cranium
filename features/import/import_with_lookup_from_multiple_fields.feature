@wip
Feature: Import a CSV file into the database with IDs looked up from multiple columns of the database

  Scenario: Successful import
    Given a database table called "dim_contact" with the following fields:
      | field_name     | field_type |
      | contact_key    | SERIAL     |
      | user_id_part_1 | TEXT       |
      | user_id_part_2 | TEXT       |
      | name           | TEXT       |
    And only the following rows in the "dim_contact" database table:
      | contact_key (i) | user_id_part_1 | user_id_part_2 | name   |
      | 11              | 1              | 1              | Alma   |
      | 12              | 1              | 2              | Korte  |
      | 21              | 2              | 1              | Szilva |
      | 22              | 2              | 2              | Barack |
    And a database table called "fct_purchases" with the following fields:
      | field_name  | field_type |
      | contact_key | INTEGER    |
      | amount      | TEXT       |
    And a "purchases.csv" data file containing:
    """
    user_id_1,user_id_2,amount
    1,1,100
    1,2,200
    2,1,300
    2,2,400
    3,1,500
    """
    And the following definition:
    """
    source :purchases do
      field :user_id_1, String
      field :user_id_2, String
      field :amount, String
    end

    source :transformed_purchases do
      field :contact_key, Integer
      field :amount, String
    end

    transform :purchases => :transformed_purchases do |record|
      record[:contact_key] = lookup :contact_key,
                                    from_table: :dim_contact,
                                    match: { :user_id_part_1 => record[:user_id_1], :user_id_part_2 => record[:user_id_2] }
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
      | 11              | 100    |
      | 12              | 200    |
      | 21              | 300    |
      | 22              | 400    |
      | -1              | 500    |
