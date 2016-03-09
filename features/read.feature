Feature: Remove source files

  Scenario:
    Given a "forms.csv" data file containing:
    """
    id,name
    1,Landing form
    2,Other form
    """
    And a "contacts_extract.csv" data file containing:
    """
    id,created,form_id
    1,2001-01-01,1
    2,2002-02-02,2
    3,2003-03-03,1
    """
    And the following definition:
    """
    source :forms do
      field :id, Integer
      field :name, String
    end

    source :contacts_extract do
      field :id, Integer
      field :created, String
      field :form_id, Integer
    end

    source :contacts do
      field :id, Integer
      field :created, String
      field :form, String
    end

    form_mapping = {}

    read :forms do |record|
      form_mapping[record[:id]] = record[:name]
    end

    transform :contacts_extract => :contacts do |record|
      record[:form] = form_mapping[record[:form_id]]
      output record
    end

    """
    When I execute the definition
    Then the process should exit successfully
    And there should be a "contacts.csv" data file in the upload directory containing:
    """
    id,created,form
    1,2001-01-01,Landing form
    2,2002-02-02,Other form
    3,2003-03-03,Landing form
    """
