@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZCDS_TDEMO0001
  as select from ZTDEMO0001 as Connections
{
  key uuid as Uuid,
  carrid as Carrid,
  connid as Connid,
  airport_from as AirportFrom,
  city_from as CityFrom,
  country_from as CountryFrom,
  airport_to as AirportTo,
  city_to as CityTo,
  country_to as CountryTo,
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
