Adds functionality to your model which allows manual sorting of records.

A required integer column named 'position' will be added to your model, and
constraints and stored procedures will be used to ensure ensures that the
`position` values remain consistent and sequentially ordered, starting from the
number 1.

```ruby
class Myer::BaseModel < Platformer::BaseModel
  positionable 
end

```

**Arguments**

scope (optional [Symbol])
:   The name of fields which this models unique position should be scoped to.

comment (optional Symbol)
:   A description of this action\_field. This description will be added to the database columns and used when generating documentation for your model.