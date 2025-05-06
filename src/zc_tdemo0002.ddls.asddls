@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_TDEMO0002
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_TDEMO0002
{
  key CarrierId,
  key ConnectionId,
  key FlightDate,
  Price,
  @Semantics.currencyCode: true
  CurrencyCode,
  PlaneTypeId,
  SeatsMax,
  SeatsOccupied,
  LocalCreateBy,
  LocalCreateAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt
  
}
