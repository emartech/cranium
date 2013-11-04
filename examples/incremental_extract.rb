require_relative 'config'

extract :contacts, end_time: Time.now-10 do |start_time, end_time|
  query <<-sql
    SELECT DISTINCT
        c.id,
        gender.choice AS gender,
        c.created,
        c._48 AS registered_on,
        contact_source.choice AS contact_source,
        pf.name AS registered_via_form,
        country.choice AS country,
        c._4 AS date_of_birth
    FROM
        %CUSTOMER_ID%_contact_0 c
        LEFT JOIN
        prof_forms pf ON c.registered_via_form = pf.id
        LEFT JOIN
        prof_choices gender ON c._5 = gender.id AND gender.element=5 AND gender.language='en'
        LEFT JOIN
        prof_choices country ON c._14 = country.id AND country.element=14 AND country.language='en'
        LEFT JOIN
        prof_choices contact_source ON c._33 = contact_source.id AND contact_source.element=33 AND contact_source.language='en'
        LEFT JOIN
        changes_log_%CUSTOMER_ID% cl ON c.id = cl.user_id
        LEFT JOIN
        contact_element ce ON ce.customer_id IN (0, %CUSTOMER_ID%) AND cl.element=ce.id
    WHERE
        -- birth_date validation
        (c._4 IS NULL OR c._4 REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
        AND
        (
            (c.created BETWEEN '#{start_time}' AND '#{end_time}')
          OR
            (ce.col_name IN ('_4', '_5', '_14', '_33', '_48') AND cl.time BETWEEN '#{start_time}' AND '#{end_time}')
        )
  sql
end
