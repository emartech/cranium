@wip
Feature: Import a CSV file into the database with new dimension values inserted when not found during lookup

  Scenario: Successful import
    Given a database table called "dim_contact" with the following fields:
      | field_name  | field_type |
      | contact_key | SERIAL     |
      | user_id     | TEXT       |
      | name        | TEXT       |
    And only the following rows in the "dim_contact" database table:
      | contact_key (i) | user_id | name |
      | 10              | 1       | Alma |
    And the current value in sequence "dim_contact_contact_key_seq" is 10
    And a database table called "fct_purchases" with the following fields:
      | field_name  | field_type |
      | contact_key | INTEGER    |
      | amount      | TEXT       |
    And a "purchases.csv" data file containing:
    """
    user_id,amount
    1,100
    2,200
    2,300
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
                                    if_missing_insert: { name: "Missing contact #{record[:user_id]}", user_id: record[:user_id] }
    end

    import :transformed_purchases do
      to :fct_purchases
      put :contact_key => :contact_key
      put :amount => :amount
    end
    """
    When I execute the definition
    Then the "fct_purchases" table should contain:
      | contact_key (i) | amount |
      | 10              | 100    |
      | 11              | 200    |
      | 11              | 300    |
    And the "dim_contact" table should contain:
      | contact_key (i) | user_id | name              |
      | 10              | 1       | Alma              |
      | 11              | 2       | Missing contact 2 |
