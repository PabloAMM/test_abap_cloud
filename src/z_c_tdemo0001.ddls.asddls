@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity Z_C_TDEMO0001
  provider contract TRANSACTIONAL_QUERY
  as projection on ZCDS_TDEMO0001
{
  key Uuid,
  Carrid,
  Connid,
  AirportFrom,
  CityFrom,
  CountryFrom,
  AirportTo,
  CityTo,
  CountryTo,
  LocalCreateBy,
  LocalCreateAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt
  
}
