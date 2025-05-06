CLASS zcl_generate_demo_data_rap DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_generate_demo_data_rap IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


*.....Insert Travel Demo Data
    INSERT ztrap_travel001 FROM
    ( SELECT
        FROM /dmo/travel
         FIELDS
         uuid(  )      AS travel_uuid,
         travel_id     AS travel_id,
         agency_id     AS /dmo/agency_id,
         customer_id   AS  customer_id,
         begin_date    AS begin_date,
         end_date      AS end_date,
         booking_fee   AS booking_fee,
         total_price   AS total_price,
         currency_code AS currency_code,
         description   AS description,
         CASE status
           WHEN 'B' THEN 'A' "Accepted
           WHEN 'X' THEN 'X' "Canceled
           ELSE 'O'          "Open
           END         AS  overall_status     ,
        createdby      AS created_by,
        createdat      AS created_at,
        lastchangedby  AS last_changed_by,
        lastchangedat  AS last_changed_at,
        lastchangedat  AS local_last_changed
        ORDER BY travel_id UP TO 200 ROWS ).

    COMMIT WORK.

*.....Insert Booking Demo Data

    INSERT ztrap_booking001 FROM
  ( SELECT
      FROM /dmo/booking AS b
       JOIN ztrap_travel001 AS zt
        ON b~travel_id = zt~travel_id
       FIELDS
       uuid(  )           AS booking_uuid,
       zt~travel_uuid     AS travel_uuid,
       b~booking_id       AS booking_id ,
       b~booking_date     AS booking_date ,
       b~customer_id      AS customer_id ,
       b~carrier_id       AS carrier_id ,
       b~connection_id    AS connection_id ,
       b~flight_date      AS flight_date ,
       b~flight_price     AS flight_price ,
       b~currency_code    AS currency_code ,
      zt~created_by       AS created_by,
      zt~last_changed_by  AS last_changed_by,
      zt~last_changed_at  AS local_last_changed_by  ).

    COMMIT WORK.

    out->write( 'Travels and Bookings demo data inserted.' ).


  ENDMETHOD.
ENDCLASS.
