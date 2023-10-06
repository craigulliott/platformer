# dynamic migrations will generate migrations to remove any unused extensions, we disable that functionality here
# because people don't always have control over which extensions are running on the database, and it can be
# very confusing when this is the reason for specs to fail
DynamicMigrations::Postgres.remove_unused_extensions = false

# store the materialized views which represent a cached representation of the
# database structure in the dynamic_migrations schema instead of public
DynamicMigrations::Postgres.cache_schema_name = :dynamic_migrations
