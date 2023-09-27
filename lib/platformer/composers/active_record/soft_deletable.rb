# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      class SoftDeletable < Parsers::FinalModels
        class ModelAlreadyDeletedError < StandardError
        end

        class ModelNotDeletedError < StandardError
        end

        class ModelDirtyError < StandardError
        end

        for_dsl :soft_deletable do |active_record_class:|
          # unless the model has already been deleted, then default the undeleted column
          # to TRUE, as this signifies that the delection has not been performed yet
          active_record_class.before_validation on: :create do
            if deleted_at.nil?
              self.undeleted = true
            end
          end

          # returns true if this model has not been soft deleted, otherwise false
          active_record_class.install_method :not_deleted? do
            deleted_at.nil?
          end

          # returns true if this model has been soft deleted, otherwise false
          active_record_class.install_method :deleted? do
            undeleted.nil?
          end

          # install callbacks which can be used around the soft delete and undelete
          active_record_class.define_model_callbacks :soft_delete, only: [:before, :after]
          active_record_class.define_model_callbacks :undelete, only: [:before, :after]
          active_record_class.define_model_callbacks :soft_delete_commit, only: [:before, :after]
          active_record_class.define_model_callbacks :undelete_commit, only: [:before, :after]

          # soft delete the current model
          # note the callbacks both inside and outside the transaction, defined above
          active_record_class.install_method :soft_delete do
            # assert the model isn't already deleted
            if deleted?
              raise ModelAlreadyDeletedError, "This #{self.class.name} is already soft deleted"
            end

            # no other changes are permitted to records when calling delete (this rule allows
            # us to safely skip all other callbacks when soft deleting)
            if changed?
              raise ModelDirtyError, "This #{self.class.name} has unsaved changed, and can not be soft deleted"
            end

            # perform the soft delete with custom callbacks
            run_callbacks :soft_delete_commit do
              transaction do
                run_callbacks :soft_delete do
                  update_columns deleted_at: Time.now, undeleted: nil
                end
              end
            end
          end

          # soft undelete the current model
          # note the callbacks both inside and outside the transaction, defined above
          active_record_class.install_method :undelete do
            # assert the model is deleted
            if not_deleted?
              raise ModelNotDeletedError, "This #{self.class.name} can not be undeleted because it is not currently deleted"
            end

            # no other changes are permitted to records when calling undelete (this rule allows
            # us to safely skip all other callbacks when undeleting)
            if changed?
              raise ModelDirtyError, "This #{self.class.name} has unsaved changed, and can not be undeleted"
            end

            # perform the undelete with custom callbacks
            run_callbacks :undelete_commit do
              transaction do
                run_callbacks :undelete do
                  update_columns deleted_at: nil, undeleted: true
                end
              end
            end
          end
        end
      end
    end
  end
end
