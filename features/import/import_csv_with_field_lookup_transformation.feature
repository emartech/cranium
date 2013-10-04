@wip
Feature: Import a CSV file into the database with IDs looked up from the database

  Scenario: Successful import
    Given a database table called "dim_contact" with the following fields:
      | field_name  | field_type |
      | contact_key | INTEGER    |
      | user_id     | INTEGER    |
      | name        | TEXT       |
    And only the following rows in the "dim_contact" database table:
      | contact_key | user_id | name  |
      | 1           | 10      | Alma  |
      | 2           | 20      | Korte |
    And a database table called "fct_purchases" with the following fields:
      | field_name  | field_type |
      | contact_key | INTEGER    |
      | amount      | INTEGER    |
    And a "purchases.csv" data file containing:
    """
    user_id,amount
    1,100
    2,200
    """
    And the following definition:
    """
    source :purchases do
      encoding "UTF-8"
      delimiter ','
      field :user_id, Integer
      field :amount, Integer
    end

    source :transformed_purchases do
      field :contact_key, Integer
      field :user_id, Integer
      field :amount, Integer
    end

    transform :purchases => :transformed_purchases do |record|
      record[:contact_key] = lookup :contact_key,
                                    from_table: :dim_contact,
                                    match_column: :user_id,
                                    to_value: record[:user_id]
    end

    import :transformed_purchases do
      to :dim_contact
      put :contact_key => :contact_key
      put :amount => :amount
    end
    """
    When I execute the definition
    Then the "fct_purchases" table should contain:
      | contact_key | amount |
      | 10          | 100    |
      | 20          | 200    |
