REGULAR_EXPRESSIONS = {
  MAC_ADDRESS: /\A([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})\Z/,
  STI_TYPE_API_ATTRIBUTE: /\A[a-z_]+\Z/,
  USD_MONEY: /\A\$?(\d+)\.(\d\d)/,
  USD_MONEY_OPTIONAL_CENTS: /\A\$?(\d+)(\.(\d\d))?\Z/,
  UUID: /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\Z/,
  USERNAME: /\A[0-9a-zA-Z]+\Z/,
  MD5: /\A[a-f0-9]{32}\Z/,
  CAMEL_CASE: /\A[A-Z][a-z0-9]*([A-Z][a-z0-9]*)*\Z/,
  TITLE_CASE: /\A[A-Z][a-z0-9]*( [A-Z][a-z0-9]*)*\Z/,
  UNDERSCORE_CASE: /\A[a-z][a-z0-9]*(_[a-z][a-z0-9]*)*\Z/,
  # keys like : models.CurriculumMissionStepsMissionStep.74f8fddc-b5af-4f67-909d-ded5e504e85e.attributes.content
  I18N_KEY: /\A(([a-zA-Z]+[a-zA-Z0-9]*)|([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}))(\.(([a-zA-Z]+[a-zA-Z0-9]*)|([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})))*\Z/
}
