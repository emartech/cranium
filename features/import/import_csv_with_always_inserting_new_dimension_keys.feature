Feature: Import a CSV file into the database with new dimension values always inserted

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
    NA,200
    NA,300
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
      record[:contact_key] = insert :contact_key,
                                    table: :dim_contact,
                                    record: {contact_key: next_value_in_sequence("dim_contact_contact_key_seq"), user_id: record[:user_id], name: "Unknown contact #{record[:user_id]}"}
      output record
    end

    import :transformed_purchases do
      into :fct_purchases
      put :contact_key
      put :amount
    end
    """
    When I execute the definition
    Then the process should exit successfully
    And the "fct_purchases" table should contain:
      | contact_key (i) | amount |
      | 11              | 100    |
      | 12              | 200    |
      | 13              | 300    |
    And the "dim_contact" table should contain:
      | contact_key (i) | user_id | name               |
      | 10              | 1       | Alma               |
      | 11              | 1       | Unknown contact 1  |
      | 12              | NA      | Unknown contact NA |
      | 13              | NA      | Unknown contact NA |


  Scenario: Example use case for the insert
    If purchases made by a predefined contact identifier (NA in this case) do not look for it insert .
    Otherwise use lookup to find or create that contact

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
    NA,200
    NA,300
    2,400
    2,500
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
      if record[:user_id] == 'NA'
        record[:contact_key] = insert :contact_key,
                                      table: :dim_contact,
                                      record: {contact_key: next_value_in_sequence("dim_contact_contact_key_seq"), user_id: record[:user_id], name: "Unknown contact #{record[:user_id]}"}
      else
        record[:contact_key] = lookup :contact_key,
                                      from_table: :dim_contact,
                                      match_column: :user_id,
                                      to_value: record[:user_id],
                                      if_not_found_then_insert: {contact_key: next_value_in_sequence("dim_contact_contact_key_seq"), name: "Unknown contact #{record[:user_id]}"}
      end
      output record
    end

    import :transformed_purchases do
      into :fct_purchases
      put :contact_key
      put :amount
    end
    """
    When I execute the definition
    Then the process should exit successfully
    And the "fct_purchases" table should contain:
      | contact_key (i) | amount |
      | 10              | 100    |
      | 11              | 200    |
      | 12              | 300    |
      | 13              | 400    |
      | 13              | 500    |
    And the "dim_contact" table should contain:
      | contact_key (i) | user_id | name               |
      | 10              | 1       | Alma               |
      | 11              | NA      | Unknown contact NA |
      | 12              | NA      | Unknown contact NA |
      | 13              | 2       | Unknown contact 2  |
