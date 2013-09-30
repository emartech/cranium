@wip
Feature: Import a CSV file into the database without any transformations

  Scenario: No destination table specified => error
    Given the following definition:
    """
    import :products do
    end
    """
    When I execute the definition
    Then the execution should fail with a message containing "<Import:Products> No destination table specified"

  Scenario:
    Given a database table called "dim_product" with the following fields:
    | field_name | field_type |
    | item       | TEXT       |
