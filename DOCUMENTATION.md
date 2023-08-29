# Platformer

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

# Introduction

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.


## Quick Start

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## Configuration

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## Models

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

### Database Configuration

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

The name of the database connection to use. This should
be the name of a database configuration block that is
defined within `config/database.yaml` and nested within
a key which matches the server\_type

An example `config/database.yaml`

```yaml
# This is the `server_type`, all postgres server configurations
# are grouped together under this key.
postgres:
  # This is the `server_name`.
  # You can define multiple postgres servers, you should
  # use different configuration blocks for different servers,
  # you do not have to create different configurations for
  # multiple databases which reside on the same server.
  my_database_server:
    # This is the default database on the server, when you
    # configure your models to use this server you can use
    # either the default database or select another one that
    # exists on this server.
    default_database: database_name
    username: craig
    password:
    host: localhost
    port: 5432
  my_other_database_server:
    default_database: database_name
    username: katy
    password:
    host: anotherhost
    port: 5432
```


#### Selecting the database for your model

Selects the server, database and schema which will be
used to store data for this model and all models which
extend this one.

All classes which extend the class where you use this DSL
will inherit this configuration, you can call this method again
on a decendent class and it will set the database configuration
for only that class and any decendents of it.

```ruby
class MyModel < PlatformModel
  database :server_type, :server_name, database_name: :my_database
end
```


**Arguments**

server\_type (required)
:   The type of this database, such as `:postgres`. This should correspond to a configuration block that is defined within `config/database.yaml`.
:   `server_type` is one of **postgres**.


server\_name (required)
:   The name of the database which should be used on this server. If you do not provide a database name then then the default database for this server will be used.


database\_name (optional)
:   The name of the database which should be used on this server. If you do not provide a database name then then the default database for this server will be used.

#### Selecting the schema for your model

For databases which support it (such as `postgres`), this is the
name of the postgres servers database schema where the data for
this model will be persisted. If you do not provide a schema name,
then the default schema (usually `public`) will be used.

It is reccomended that all models which are within a namespace
be placed in their own schema. For example.

```ruby
# All of our model classes extend from PlatformModel.
class PlatformModel
  # A default database server configuration for all models in
  # the platform to use
  # and the default database on that server
  database :postgres, :primary
end

# A base class within the Users namespace for all Users models
# to extend from.
class UsersUsersModel
  # all models within the Usrs namespace should be stored
  # in the "users" schema within our database
  schema :users

  # optionally, you could call `database` again here and it
  # would change the server and/or database which would be
  # used for only the models within the Users namespace
end

# Both of these models will be stored in the `users` schema
# in our database (`users`.`users` and `users`.`avatars`).
class Users:UserModel < UsersModel

end
class Users:AvatarModel < UsersModel

end
```


### State Machines

A state machine simplifies the expression of business logic for a model
by organizing it into distinct states and permitted transitions between
those states. This is particularly useful for managing workflows, multi-step
background processes, and asynchronous jobs. Use the state method to define
the various states your model can occupy; the first state specified will
serve as the default. Employ the event method to outline allowed transitions
between states. While it's common to associate state machines with
manually-triggered actions, like a user invoking :publish, they are also
invaluable when integrated with callbacks, background jobs, webhooks, and
external services.

#### Adding a state machine to your model

```ruby
class MyModel < PlatformModel
  state_machine :name, :comment, log_transitions: boolean
end
```

**Arguments**

name (required Symbol)
:   A name for this state machine. If you omit this option then the default name `:state` will be assumed. This option is typically only required if you need to have multiple state machines on the same model.

comment (required Symbol)
:   A description of this state machine. This description will be used when generating documentation for your model.

log\_transitions (optional Boolean)
:   If set to true, a dedicated table will be created to automatically record transitions for this model. If the model is named `:projects`, the automatically generated table will be called `:project_transitions`.

##### Configuring your state machine

** Adding a state **

Add a state to your state machine. A state machine should comprise
multiple states. The first state you define will serve as the default
state for the machine.

```ruby
class MyModel < PlatformModel
  state_machine :name, :comment
    ...
    state name, comment: symbol, requires_presence_of: symbol, requires_absence_of: symbol
    ...
  end
end

```

Arguments

name (required Symbol)
:    Choose a name for the state that is preferably a past or present participle. For example, use `:activated` or `:published` for stable states and `:publishing` or `:activating` for transient, short-lived states that are automatically transitioned away from. Crucially, avoid using verbs like `:activate` or `:publish` for state names, as they can conflict with your event names.

comment (optional String)
:   A description of this state. This description will be used when generating documentation for your model.

requires\_presence\_of (optional Array[Symbol])
:    Specify an optional array of field names for the model, each of which must contain a value when the model is in, or transitioning to, this state. This requirement is common in state machines, as models often accumulate data while advancing through different states. For instance, transitioning to the `:published` state may necessitate that the `:published_by` field includes a user.

requires\absence\_of (optional Array[Symbol])
:    Specify an optional array of field names for this model. When the model is in or transitioning to this state, these fields must be empty. For instance, if the state machine is in the `:unpublished` state, the `:published_by` field should have no user value.

** Adding an action **

Create an action to outline permitted transitions between your model'sstates. Upon triggering, the action will sequentially evaluate and executethe first allowable transition. Any subscribed business logic, such ascallbacks or messages, will then be executed. The model's internal statewill update to the target state specified by the `to: :state` option, andany other pending changes will be saved. If no transitions are permissible,either due to a mismatch with the configured `from: [:state, :other_state]`or because any provided guards return false, then an error will be raised.


```ruby
class MyModel
  state_machine name: symbol, comment: symbol, log_transitions: boolean do
    action name, comment: symbol, from: symbol, to: symbol, guards: symbol
  end
end

```

Arguments

name (required Symbol)
:     Choose a verb for your action name that clearly describes the action required to transition between states. For instance, if your model has `:reviewing` and `:published` states, a suitable action name for transitioning would be `:publish`. If multiple actions share the same name, they will be attempted in sequence and execution will halt at the first successful transition.

comment (optional String)
:   A description of this state. This description will be used when generating documentation for your model.

from (optional Symbol)
:     Specify an optional state name, or multiple state names, from which this action is allowed to transition. If set, the action will only be permitted if the model's current state matches one of the provided states.

to (optional Symbol)
:    Upon successful execution of this action, your model will transition to this state.

guards (optional Array[Symbol])
:     Define a method name or multiple methods that must each return true for the transition to be allowed. If any of the specified guards do not return true, the system will attempt the next action with the same name as the current one.
