@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_TDEMO0002
  as select from ZTDEMO0002 as flight
{
  key carrier_id as CarrierId,
  key connection_id as ConnectionId,
  key flight_date as FlightDate,
  @Semantics.amount.currencyCode: 'CurrencyCode'
  price as Price,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_CurrencyStdVH', 
    entity.element: 'Currency', 
    useForValidation: true
  } ]
  currency_code as CurrencyCode,
  plane_type_id as PlaneTypeId,
  seats_max as SeatsMax,
  seats_occupied as SeatsOccupied,
  @Semantics.user.createdBy: true
  local_create_by as LocalCreateBy,
  @Semantics.systemDateTime.createdAt: true
  local_create_at as LocalCreateAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt
  
}
