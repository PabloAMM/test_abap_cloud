CLASS lhc_zcds_tdemo0001 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Connections  ##NEEDED
        RESULT result  ##NEEDED,
      CheckSemanticKey FOR VALIDATE ON SAVE
        IMPORTING keys FOR Connections~CheckSemanticKey,
      GetCities FOR DETERMINE ON SAVE
        IMPORTING keys FOR Connections~GetCities.
ENDCLASS.

CLASS lhc_zcds_tdemo0001 IMPLEMENTATION.
  METHOD get_global_authorizations  ##NEEDED.
  ENDMETHOD.
  METHOD CheckSemanticKey.

    DATA: read_keys   TYPE TABLE FOR READ IMPORT zcds_tdemo0001  ##NEEDED,
          connections TYPE TABLE FOR READ RESULT zcds_tdemo0001.

    read_keys = CORRESPONDING #( keys ).

    READ ENTITIES OF zcds_tdemo0001 IN LOCAL MODE
    ENTITY Connections
    FIELDS ( Uuid Carrid Connid )
    WITH CORRESPONDING #( keys )
    RESULT connections.

    LOOP AT connections INTO DATA(ls_connections).
*.....Persistence table
      SELECT FROM ztdemo0001
          FIELDS uuid
          WHERE carrid = @ls_connections-Carrid
            AND connid = @ls_connections-Connid
            AND uuid  <> @ls_connections-Uuid

      UNION
*.....Draft table
      SELECT FROM ztdemo0001_d
          FIELDS uuid
          WHERE carrid = @ls_connections-Carrid
            AND connid = @ls_connections-Connid
            AND uuid  <> @ls_connections-Uuid
       INTO TABLE @DATA(lt_check_result).

    ENDLOOP.

    CHECK lt_check_result IS NOT INITIAL.

    DATA(lo_message) = me->new_message( id       = 'ZRAP001'
                                        number   = '001'
                                        severity = ms-error
                                        v1       = ls_connections-Carrid
                                        v2       = ls_connections-Connid ).


    reported-connections = VALUE #( ( %tky            = ls_connections-%tky
                                      %msg            = lo_message
                                      %element-carrid = if_abap_behv=>mk-on
                                      %element-connid = if_abap_behv=>mk-on ) ).

    failed-connections = VALUE #( ( %tky = ls_connections-%tky ) ).

  ENDMETHOD.

  METHOD GetCities.
    DATA: lt_read_data TYPE TABLE FOR READ RESULT zcds_tdemo0001.

    READ ENTITIES OF zcds_tdemo0001 IN LOCAL MODE
    ENTITY Connections
    FIELDS ( AirportFrom AirportTo )
    WITH CORRESPONDING #( keys )
    RESULT lt_read_data.

    LOOP AT lt_read_data INTO DATA(ls_read_data).

      SELECT SINGLE FROM /DMO/I_Airport
          FIELDS City,CountryCode
          WHERE AirportID = @ls_read_data-AirportFrom
          INTO ( @ls_read_data-CityFrom,@ls_read_data-CountryFrom ).

      SELECT SINGLE FROM /DMO/I_Airport
         FIELDS City,CountryCode
         WHERE AirportID = @ls_read_data-AirportTo
         INTO ( @ls_read_data-CityTo,@ls_read_data-CountryTo ).

      MODIFY lt_read_data FROM ls_read_data.

    ENDLOOP.


    DATA: lt_update_data TYPE TABLE FOR UPDATE zcds_tdemo0001.
    lt_update_data = CORRESPONDING #( lt_read_data ).

    MODIFY ENTITIES OF zcds_tdemo0001 IN LOCAL MODE
    ENTITY Connections
    UPDATE
    FIELDS ( CityFrom CountryFrom CityTo CountryTo )
    WITH lt_update_data
    REPORTED DATA(lt_reported_records).

    reported-connections = CORRESPONDING #( lt_reported_records-connections ).

  ENDMETHOD.

ENDCLASS.
