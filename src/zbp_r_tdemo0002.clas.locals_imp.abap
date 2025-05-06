CLASS lhc_zr_tdemo0002 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR flight
        RESULT result,
      ValidatePrice FOR VALIDATE ON SAVE
        IMPORTING keys FOR flight~ValidatePrice,
      ValidateCurrency FOR VALIDATE ON SAVE
        IMPORTING keys FOR flight~ValidateCurrency.
ENDCLASS.

CLASS lhc_zr_tdemo0002 IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD ValidatePrice.

    DATA failed_record   LIKE LINE OF failed-flight.
    DATA reported_record LIKE LINE OF reported-flight.

    READ ENTITIES OF zr_tdemo0002 IN LOCAL MODE
    ENTITY flight
    FIELDS ( price )
    WITH CORRESPONDING #( keys )
    RESULT DATA(flight).

    LOOP AT flight INTO DATA(ls_flight).

      IF ls_flight-Price < 0.

        failed-flight   = VALUE #( ( %tky = ls_flight-%tky ) ).
        reported-flight = VALUE #( ( %tky = ls_flight-%tky
                                     %element-price = if_abap_behv=>mk-on
                                     %msg = me->new_message( id       = 'ZRAP001'
                                                             number   = '004'
                                                             severity = if_abap_behv_message=>severity-error ) ) ).

      ENDIF.

    ENDLOOP.


  ENDMETHOD.

  METHOD ValidateCurrency.

    DATA: lv_exists TYPE abap_bool.



    READ ENTITIES OF zr_tdemo0002 IN LOCAL MODE
    ENTITY flight
    FIELDS ( CurrencyCode )
    WITH CORRESPONDING #( keys )
    RESULT DATA(flight).

    LOOP AT flight INTO DATA(ls_flight).

      lv_exists = abap_false.

      SELECT SINGLE FROM I_Currency
      FIELDS @abap_true
      WHERE Currency = @ls_flight-CurrencyCode
      INTO @lv_exists.


      IF lv_exists EQ abap_false.

        failed-flight   = VALUE #( ( %tky = ls_flight-%tky ) ).
        reported-flight = VALUE #( ( %tky = ls_flight-%tky
                                     %element-price = if_abap_behv=>mk-on
                                     %msg = me->new_message( id       = 'ZRAP001'
                                                             number   = '005'
                                                             severity = if_abap_behv_message=>severity-error
                                                             v1       = ls_flight-CurrencyCode  ) ) ).

      ENDIF.


    ENDLOOP.


  ENDMETHOD.

ENDCLASS.
