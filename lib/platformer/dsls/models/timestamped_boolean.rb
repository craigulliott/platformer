module Platformer
  module DSLs
    module Models
      module Deletable
        def self.included klass
          klass.define_dsl :timestamped_boolean do
            description <<~DESCRIPTION
              Timestamped booleans are boolean field which also include a
              timestamp for when the state was set.

              The combination of a Nullable boolean and Nullable timestamp
              column is very useful within postgres, as it allows for the
              creation of valid constraints and indexes which cover rows which
              fall into one of the boolean states.

              For example, a User could have many unpublished Avatars, but only
              be permitted one published Avatar.

              Various convenience methods, postgres constraints and the installation of
              new active record callbacks will also be created for soft deletable models
            DESCRIPTION

            required :past_participle, :symbol do
              description <<~DESCRIPTION
                The name of this timestamped boolean, such as added,
                published, claimed or revoked.
              DESCRIPTION
            end
          end
        end
      end
    end
  end
end
