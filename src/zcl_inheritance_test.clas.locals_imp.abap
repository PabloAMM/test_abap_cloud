*......Inheritance Test

*CLASS lcl_plane DEFINITION.
*  PUBLIC SECTION.
*
*    TYPES: BEGIN OF ts_attributes,
*             name  TYPE string,
*             value TYPE string,
*           END OF ts_attributes,
** declare table - do not allow the same attribute to be used more than once
*           tt_attributes TYPE SORTED TABLE OF ts_attributes WITH UNIQUE KEY name.
*
*
*    METHODS constructor IMPORTING iv_manufacturer TYPE string
*                                  iv_type         TYPE string.
*    METHODS: get_Attributes RETURNING VALUE(rt_Attributes) TYPE tt_attributes.
*
*
*  PROTECTED SECTION.
*    DATA manufacturer TYPE string.
*    DATA type TYPE string.
*
*  PRIVATE SECTION.
*
*ENDCLASS.
*
*
*CLASS lcl_plane IMPLEMENTATION.
*  METHOD constructor.
*    manufacturer = iv_manufacturer.
*    type = iv_type.
*  ENDMETHOD.
*
*
*  METHOD get_attributes.
*    rt_attributes = VALUE #( ( name = 'MANUFACTURER' value = manufacturer )
*    ( name = 'TYPE' value = type ) ) .
*  ENDMETHOD.
*
*
*ENDCLASS.
*
*
*CLASS lcl_cargo_plane DEFINITION INHERITING FROM lcl_plane.
*  PUBLIC SECTION.
*    METHODS constructor IMPORTING iv_manufacturer TYPE string
*                                  iv_type         TYPE string
*                                  iv_cargo        TYPE i.
*    METHODS get_attributes REDEFINITION.
*  PRIVATE SECTION.
*    DATA cargo TYPE i.
*ENDCLASS.
*
*
*CLASS lcl_cargo_plane IMPLEMENTATION.
*  METHOD constructor.
*
*
*    super->constructor( iv_manufacturer = iv_manufacturer iv_type = iv_type ).
*    cargo = iv_cargo.
*
*
*  ENDMETHOD.
*
*
*  METHOD get_attributes.
*
*
** method uses protected attributes of superclass
*
*
*    rt_attributes = VALUE #( ( name = 'MANUFACTURER' value = manufacturer )
*    ( name = 'TYPE' value = type )
*    ( name ='CARGO' value = cargo ) ).
*
*
*  ENDMETHOD.
*
*
*ENDCLASS.
*
*
*CLASS lcl_passenger_plane DEFINITION INHERITING FROM lcl_Plane.
*  PUBLIC SECTION.
*    METHODS constructor IMPORTING iv_manufacturer TYPE string
*                                  iv_type         TYPE string
*                                  iv_seats        TYPE i.
*    METHODS get_Attributes REDEFINITION.
*  PRIVATE SECTION.
*    DATA seats TYPE i.
*ENDCLASS.
*
*
*CLASS lcl_passenger_plane IMPLEMENTATION.
*
*
*  METHOD constructor.
*
*
*    super->constructor( iv_manufacturer = iv_manufacturer iv_type = iv_type ).
*
*
*  ENDMETHOD.
*
*
*  METHOD get_attributes.
*
*
** Redefinition uses call of superclass implementation
*
*    rt_attributes = super->get_attributes( ).
*    rt_Attributes = VALUE #( BASE rt_attributes ( name = 'SEATS' value = seats ) ).
*
*  ENDMETHOD.
*
*ENDCLASS.


*......Exception Class

CLASS lcx_no_connection DEFINITION INHERITING FROM cx_static_Check.
  PUBLIC SECTION.
    INTERFACES if_t100_message.

    METHODS constructor
      IMPORTING
        textid           LIKE if_t100_message=>t100key OPTIONAL
        previous         LIKE previous OPTIONAL
        airlineid        TYPE /dmo/carrier_id OPTIONAL
        connectionnumber TYPE /dmo/connection_id OPTIONAL.
    CONSTANTS:
      BEGIN OF lcx_no_connection,
        msgid TYPE symsgid VALUE 'ZRAP001',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE 'AIRLINEID',
        attr2 TYPE scx_attrname VALUE 'CONNECTIONNUMBER',
        attr3 TYPE scx_attrname VALUE 'attr3',
        attr4 TYPE scx_attrname VALUE 'attr4',
      END OF lcx_no_connection.

    DATA airlineid TYPE /dmo/carrier_id READ-ONLY.
    DATA connectionnumber TYPE /dmo/connection_id READ-ONLY.

ENDCLASS.

CLASS lcx_no_Connection IMPLEMENTATION.
  METHOD constructor.

    super->constructor( previous = previous ).

    me->airlineid = airlineid.
    me->connectionnumber = connectionnumber.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = lcx_no_connection.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.


  ENDMETHOD.

ENDCLASS.

CLASS lcl_connection DEFINITION.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
                i_airlineid        TYPE /dmo/carrier_id
                i_connectionnumber TYPE /dmo/connection_id
      RAISING   lcx_no_connection.


  PRIVATE SECTION.
    DATA AirlineId TYPE /dmo/carrier_id.
    DATA ConnectionNumber TYPE /dmo/connection_id.
    DATA fromAirport TYPE /dmo/airport_from_id.
    DATA toAirport TYPE /dmo/airport_to_id.
ENDCLASS.


CLASS lcl_Connection IMPLEMENTATION.


  METHOD constructor.
    DATA fromairport TYPE /dmo/airport_from_Id.
    DATA toairport TYPE /dmo/airport_to_id.


    SELECT SINGLE FROM /dmo/connection
    FIELDS airport_from_id, airport_to_id
    WHERE carrier_id = @i_airlineid
    AND connection_id = @i_connectionnumber
    INTO ( @fromairport, @toairport ).


    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE lcx_no_connection
        EXPORTING
          airlineid        = i_airlineid
          connectionnumber = i_connectionnumber.
    ELSE.
      me->connectionnumber = i_connectionnumber.
      me->fromairport = fromairport.
      me->toairport = toairport.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
