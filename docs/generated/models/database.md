Selects the server, database and schema which will be
used to store data for this model and all models which
extend this one.

All classes which extend the class where you use this DSL
will inherit this configuration, you can call this method again
on a decendent class and it will set the database configuration
for only that class and any decendents of it.

```ruby
class Myer::BaseModel < Platformer::BaseModel
  database :server_type, :server_name
end

```

**Arguments**

server\_type (required Symbol)
:   The type of this database, such as `postgres`  This should correspond to a configuration block that is defined within `config/database.yaml`.

server\_name (required Symbol)
:   The name of the database connection to use. This should be the name of a database configuration block that is defined within `config/database.yaml` and nested within a key which matches the server\_type  An example `config/database.yaml`  ```yaml # This is the `server\_type`, all postgres server configurations # are grouped together under this key. postgres:   # This is the `server\_name`.   # You can define multiple postgres servers, you should   # use different configuration blocks for different servers,   # you do not have to create different configurations for   # multiple databases which reside on the same server.   my\_database\_server:     # This is the default database on the server, when you     # configure your models to use this server you can use     # either the default database or select another one that     # exists on this server.     default\_database: database\_name     username: craig     password:     host: localhost     port: 5432   my\_other\_database\_server:     default\_database: database\_name     username: katy     password:     host: anotherhost     port: 5432 ```

database\_name (optional Symbol)
:   The name of the database which should be used on this server. If you do not provide a database name then then the default database for this server will be used.