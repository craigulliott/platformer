module Platformer
  module Generators
    module FromDatabase
      module Models
        ASSOCIATIONS = {
          "Studios::AttendanceModel": {
            belongs_to: {
              booking: {
                has_lambda: false
              },
              check_in_user: {
                class_name: "Users::User",
                has_lambda: false
              },
              check_out_user: {
                class_name: "Users::User",
                has_lambda: false
              },
              guide: {
                class_name: "Users::User",
                has_lambda: false
              }
            },
            has_one: {
              organization: {
                through: "booking",
                has_lambda: false
              },
              location: {
                through: "booking",
                has_lambda: false
              },
              user: {
                through: "booking",
                has_lambda: false
              }
            },
            has_many: {
              note_involvements: {
                class_name: "Notes::Involvement",
                has_lambda: false
              },
              notes: {
                class_name: "Notes::Note",
                through: "note_involvements",
                has_lambda: false
              },
              photo_involvements: {
                class_name: "Studios::PhotoInvolvement",
                has_lambda: false
              },
              photos: {
                through: "photo_involvements",
                class_name: "Studios::Photo",
                has_lambda: false
              }
            }
          },
          "Studios::BookingModel": {
            has_many: {
              log_entries: {
                as: "referencing",
                class_name: "Logging::LogEntry",
                has_lambda: false
              },
              attendances: {
                has_lambda: false
              },
              booking_instances: {
                has_lambda: false
              },
              participations: {
                class_name: "Communication::Participations::Child",
                has_lambda: false
              },
              invoice_bookings: {
                class_name: "Billing::InvoiceBookings::InvoiceBooking",
                has_lambda: false
              },
              slots: {
                foreign_key: "occasion_id",
                primary_key: "occasion_id",
                has_lambda: true
              }
            },
            belongs_to: {
              location: {
                has_lambda: false
              },
              occasion: {
                has_lambda: false
              },
              organization: {
                class_name: "Organizations::Organization",
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              guide: {
                class_name: "Users::User",
                has_lambda: false
              },
              author: {
                class_name: "Users::User",
                has_lambda: false
              },
              subscription: {
                class_name: "Billing::Subscription",
                has_lambda: false
              }
            },
            has_one: {
              invoice_booking_deposit: {
                class_name: "Billing::InvoiceBookings::Deposit",
                has_lambda: true
              },
              invoice_booking_balance: {
                class_name: "Billing::InvoiceBookings::Balance",
                has_lambda: true
              }
            }
          },
          "Checklists::ItemModel": {
            belongs_to: {
              version: {
                has_lambda: false
              }
            },
            has_many: {
              submission_items: {
                has_lambda: false
              }
            }
          },
          "Checklists::SubmissionModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              approver: {
                class_name: "Users::User",
                has_lambda: false
              },
              version: {
                has_lambda: false
              }
            },
            has_many: {
              submission_items: {
                has_lambda: false
              },
              comments: {
                has_lambda: false
              }
            }
          },
          "Curriculum::Assets::AssetModel": {
            has_many: {
              asset_versions: {
                has_lambda: false
              }
            },
            has_one: {
              latest_version: {
                class_name: "Curriculum::AssetVersion",
                has_lambda: true
              }
            },
            belongs_to: {
              course: {
                has_lambda: false
              }
            }
          },
          "Marketing::EventModel": {
            belongs_to: {
              public_session: {
                has_lambda: false
              }
            }
          },
          "Communication::Emails::EmailModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              organization: {
                class_name: "Organizations::Organization",
                has_lambda: false
              },
              sender: {
                class_name: "Users::User",
                has_lambda: false
              },
              replying_to: {
                class_name: "Emails::Inbound",
                foreign_key: "replying_to_id",
                has_lambda: false
              },
              referencing: {
                polymorphic: true,
                has_lambda: false
              },
              team: {
                class_name: "Staff::Team",
                has_lambda: false
              },
              handled_by: {
                class_name: "Users::User",
                has_lambda: false
              },
              claimed_by: {
                class_name: "Users::User",
                has_lambda: false
              }
            },
            has_many: {
              email_events: {
                foreign_key: "mandrill_email_id",
                primary_key: "mandrill_id",
                has_lambda: false
              },
              email_recipients: {
                has_lambda: false
              },
              email_attachments: {
                has_lambda: false
              },
              notes: {
                class_name: "Notes::Note",
                has_lambda: false
              }
            }
          },
          "Staff::EmployeeReviewModel": {
            belongs_to: {
              author: {
                class_name: "Users::User",
                has_lambda: false
              },
              employee: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Hardware::Components::ComponentModel": {
            belongs_to: {
              location: {
                class_name: "Studios::Location",
                has_lambda: false
              },
              vendor: {
                has_lambda: false
              },
              parent_component: {
                class_name: "Hardware::Components::Component",
                has_lambda: false
              }
            },
            has_many: {
              notes: {
                has_lambda: false
              },
              heartbeats: {
                has_lambda: false
              }
            }
          },
          "Hardware::HeartbeatModel": {
            belongs_to: {
              component: {
                class_name: "Hardware::Components::Component",
                has_lambda: false
              }
            }
          },
          "Incidents::IncidentModel": {
            belongs_to: {
              location: {
                class_name: "Studios::Location",
                has_lambda: false
              },
              author: {
                class_name: "Users::User",
                has_lambda: false
              },
              handled_by: {
                class_name: "Users::User",
                has_lambda: false
              },
              owner: {
                class_name: "Users::User",
                has_lambda: false
              }
            },
            has_many: {
              attachments: {
                has_lambda: false
              },
              involvements: {
                has_lambda: false
              },
              users: {
                through: "involvements",
                class_name: "Users::User",
                has_lambda: false
              },
              tasks: {
                has_lambda: false
              }
            }
          },
          "Incidents::TaskModel": {
            belongs_to: {
              incident: {
                class_name: "Incidents::Incident",
                has_lambda: false
              },
              author: {
                class_name: "Users::User",
                has_lambda: false
              },
              assignor: {
                class_name: "Users::User",
                has_lambda: false
              },
              assignee: {
                class_name: "Users::User",
                has_lambda: false
              },
              team: {
                class_name: "Staff::Team",
                has_lambda: false
              }
            }
          },
          "Billing::InvoiceBookings::InvoiceBookingModel": {
            belongs_to: {
              booking: {
                class_name: "Studios::Booking",
                has_lambda: false
              },
              invoice: {
                has_lambda: false
              }
            },
            has_one: {
              organization: {
                through: "invoice",
                has_lambda: false
              },
              booking_balance_invoice_bookings: {
                through: "booking",
                source: "invoice_booking_balance",
                class_name: "InvoiceBookings::Balance",
                has_lambda: true
              }
            },
            has_many: {
              invoice_booking_discounts: {
                has_lambda: false
              }
            }
          },
          "Billing::InvoiceBookingDiscountModel": {
            belongs_to: {
              invoice_booking: {
                class_name: "InvoiceBookings::InvoiceBooking",
                has_lambda: false
              }
            },
            has_one: {
              invoice: {
                through: "invoice_booking",
                has_lambda: false
              },
              organization: {
                through: "invoice",
                has_lambda: false
              },
              booking: {
                through: "invoice_booking",
                has_lambda: false
              }
            }
          },
          "Billing::InvoiceProductPurchaseDiscountModel": {
            belongs_to: {
              invoice_product_purchase: {
                has_lambda: false
              }
            },
            has_one: {
              invoice: {
                through: "invoice_product_purchase",
                has_lambda: false
              },
              organization: {
                through: "invoice",
                has_lambda: false
              }
            }
          },
          "Opportunities::OpportunityModel": {
            belongs_to: {
              owner: {
                class_name: "Users::User",
                has_lambda: false
              },
              stage_changer: {
                class_name: "Users::User",
                has_lambda: false
              },
              team: {
                class_name: "Staff::Team",
                has_lambda: false
              },
              organization: {
                class_name: "Organizations::Organization",
                has_lambda: false
              },
              previous_opportunity: {
                class_name: "Opportunities::Opportunity",
                has_lambda: false
              }
            },
            has_many: {
              delayed_stage_changes: {
                has_lambda: false
              },
              assignments: {
                class_name: "Opportunities::Assignments::Assignment",
                has_lambda: false
              },
              mailchimp_opportunity_syncs: {
                has_lambda: false
              }
            }
          },
          "Projects::ExecutionModel": {
            belongs_to: {
              project: {
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Projects::MistakeModel": {
            belongs_to: {
              project: {
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Leads::LeadModel": {
            belongs_to: {
              public_session: {
                class_name: "Marketing::PublicSession",
                has_lambda: false
              },
              duplicate_of: {
                class_name: "Lead",
                has_lambda: false
              },
              organization: {
                class_name: "Organizations::Organization",
                has_lambda: false
              },
              owner: {
                class_name: "Users::User",
                has_lambda: false
              },
              location: {
                class_name: "Studios::Location",
                has_lambda: false
              },
              referred_by: {
                class_name: "Users::User",
                has_lambda: false
              }
            },
            has_many: {
              duplicates: {
                class_name: "Lead",
                foreign_key: "duplicate_of_id",
                has_lambda: true
              },
              lead_interests: {
                has_lambda: false
              },
              interests: {
                through: "lead_interests",
                has_lambda: false
              }
            }
          },
          "Leads::TaskModel": {
            belongs_to: {
              organization: {
                class_name: "Organizations::Organization",
                has_lambda: false
              },
              author: {
                class_name: "Users::User",
                has_lambda: false
              },
              assignor: {
                class_name: "Users::User",
                has_lambda: false
              },
              assignee: {
                class_name: "Users::User",
                has_lambda: false
              },
              team: {
                class_name: "Staff::Team",
                has_lambda: false
              }
            }
          },
          "Library::EngineConfigurationOptionVersionModel": {
            belongs_to: {
              engine_configuration_option: {
                has_lambda: false
              },
              engine_configuration_template_version: {
                has_lambda: false
              },
              source_engine_configuration_option_version: {
                class_name: "EngineConfigurationOptionVersion",
                has_lambda: false
              },
              required_if_engine_configuration_option: {
                class_name: "EngineConfigurationOption",
                has_lambda: false
              }
            },
            has_one: {
              engine_version: {
                through: "engine_constant_version",
                has_lambda: false
              }
            }
          },
          "Library::EngineEventParameterVersionModel": {
            belongs_to: {
              engine_event_parameter: {
                has_lambda: false
              },
              engine_event_version: {
                has_lambda: false
              },
              source_engine_event_parameter_version: {
                class_name: "EngineEventParameterVersion",
                has_lambda: false
              },
              widget: {
                has_lambda: false
              }
            },
            has_one: {
              engine: {
                through: "engine_event_parameter",
                has_lambda: false
              }
            }
          },
          "Library::EngineMethodParameterVersionModel": {
            belongs_to: {
              engine_method_parameter: {
                has_lambda: false
              },
              engine_method_version: {
                has_lambda: false
              },
              source_engine_method_parameter_version: {
                class_name: "EngineMethodParameterVersion",
                has_lambda: false
              },
              engine_configuration_option: {
                has_lambda: false
              },
              widget: {
                has_lambda: false
              }
            },
            has_one: {
              engine: {
                through: "engine_method_parameter",
                has_lambda: false
              }
            }
          },
          "Library::EngineMethodVersionModel": {
            belongs_to: {
              engine_method: {
                has_lambda: false
              },
              engine_version: {
                has_lambda: false
              },
              source_engine_method_version: {
                class_name: "EngineMethodVersion",
                has_lambda: false
              },
              engine_configuration_option: {
                has_lambda: false
              }
            },
            has_one: {
              engine: {
                through: "engine_version",
                has_lambda: false
              }
            },
            has_many: {
              engine_method_tips: {
                has_lambda: false
              },
              engine_method_modules: {
                has_lambda: false
              },
              engine_modules: {
                through: "engine_method_modules",
                has_lambda: false
              },
              undeleted_engine_modules: {
                through: "engine_method_modules",
                source: "engine_module",
                class_name: "EngineModule",
                has_lambda: true
              },
              engine_method_parameter_versions: {
                has_lambda: false
              },
              undeleted_engine_method_parameter_versions: {
                class_name: "EngineMethodParameterVersion",
                has_lambda: true
              }
            }
          },
          "Library::ObjectEventParameterVersionModel": {
            belongs_to: {
              object_event_parameter: {
                has_lambda: false
              },
              object_event_version: {
                has_lambda: false
              },
              source_object_event_parameter_version: {
                class_name: "ObjectEventParameterVersion",
                has_lambda: false
              },
              object_constant: {
                has_lambda: false
              },
              widget: {
                has_lambda: false
              }
            },
            has_one: {
              object: {
                through: "object_event_parameter",
                has_lambda: false
              }
            }
          },
          "Library::ObjectMethodParameterVersionModel": {
            belongs_to: {
              object_method_parameter: {
                has_lambda: false
              },
              object_method_version: {
                has_lambda: false
              },
              source_object_method_parameter_version: {
                class_name: "ObjectMethodParameterVersion",
                has_lambda: false
              },
              object_configuration_value: {
                has_lambda: false
              },
              object_constant: {
                has_lambda: false
              },
              widget: {
                has_lambda: false
              }
            },
            has_one: {
              object: {
                through: "object_method_parameter",
                has_lambda: false
              }
            }
          },
          "Library::ObjectMethodVersionModel": {
            belongs_to: {
              object_method: {
                has_lambda: false
              },
              object_version: {
                has_lambda: false
              },
              source_object_method_version: {
                class_name: "ObjectMethodVersion",
                has_lambda: false
              },
              object_configuration_value: {
                has_lambda: false
              }
            },
            has_one: {
              object: {
                through: "object_version",
                has_lambda: false
              }
            },
            has_many: {
              object_method_modules: {
                has_lambda: false
              },
              engine_modules: {
                through: "object_method_modules",
                has_lambda: false
              },
              object_method_tips: {
                has_lambda: false
              },
              undeleted_engine_modules: {
                through: "object_method_modules",
                source: "engine_module",
                class_name: "EngineModule",
                has_lambda: true
              },
              object_method_parameter_versions: {
                has_lambda: false
              },
              undeleted_object_method_parameter_versions: {
                class_name: "ObjectMethodParameterVersion",
                has_lambda: true
              }
            }
          },
          "Library::ObjectVersionModel": {
            belongs_to: {
              object: {
                has_lambda: false
              },
              publisher: {
                class_name: "Users::User",
                has_lambda: false
              },
              engine_version: {
                has_lambda: false
              }
            },
            has_one: {
              engine: {
                through: "engine_version",
                has_lambda: false
              },
              source_object_version: {
                class_name: "ObjectVersion",
                has_lambda: false
              }
            },
            has_many: {
              object_method_versions: {
                has_lambda: false
              },
              undeleted_object_method_versions: {
                class_name: "ObjectMethodVersion",
                has_lambda: true
              },
              object_methods: {
                through: "object_method_versions",
                has_lambda: false
              },
              undeleted_object_methods: {
                through: "undeleted_object_method_versions",
                class_name: "ObjectMethodVersion",
                has_lambda: false
              },
              object_included_engine_method_versions: {
                has_lambda: false
              },
              object_included_engine_methods: {
                through: "object_included_engine_method_versions",
                has_lambda: false
              },
              undeleted_object_included_engine_method_versions: {
                class_name: "ObjectIncludedEngineMethodVersion",
                has_lambda: true
              },
              engine_methods: {
                through: "undeleted_object_included_engine_method_versions",
                has_lambda: false
              },
              engine_method_versions: {
                through: "engine_methods",
                has_lambda: true
              },
              object_event_versions: {
                has_lambda: false
              },
              undeleted_object_event_versions: {
                class_name: "ObjectEventVersion",
                has_lambda: true
              },
              object_events: {
                through: "object_event_versions",
                has_lambda: false
              },
              undeleted_object_events: {
                through: "undeleted_object_event_versions",
                class_name: "ObjectEventVersion",
                has_lambda: false
              },
              object_included_engine_event_versions: {
                has_lambda: false
              },
              object_included_engine_events: {
                through: "object_included_engine_event_versions",
                has_lambda: false
              },
              undeleted_object_included_engine_event_versions: {
                class_name: "ObjectIncludedEngineEventVersion",
                has_lambda: true
              },
              engine_events: {
                through: "undeleted_object_included_engine_event_versions",
                has_lambda: false
              },
              engine_event_versions: {
                through: "engine_events",
                has_lambda: true
              },
              object_constant_versions: {
                has_lambda: false
              },
              undeleted_object_constant_versions: {
                class_name: "ObjectConstantVersion",
                has_lambda: true
              },
              object_constants: {
                through: "object_constant_versions",
                has_lambda: false
              },
              object_configuration_templates: {
                has_lambda: false
              },
              undeleted_object_configuration_templates: {
                class_name: "ObjectConfigurationTemplate",
                has_lambda: true
              },
              object_configuration_values: {
                through: "object_configuration_templates",
                has_lambda: false
              },
              undeleted_object_configuration_values: {
                through: "undeleted_object_configuration_templates",
                class_name: "ObjectConfigurationValue",
                has_lambda: true
              },
              engine_configuration_template_versions: {
                through: "engine_version",
                has_lambda: true
              },
              engine_configuration_templates: {
                through: "engine_configuration_template_versions",
                has_lambda: false
              },
              object_reactions: {
                has_lambda: false
              },
              undeleted_object_reactions: {
                class_name: "ObjectReaction",
                has_lambda: true
              }
            }
          },
          "Organizations::MembershipModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              initiated_by: {
                class_name: "Users::User",
                has_lambda: false
              },
              accepted_by: {
                class_name: "Users::User",
                has_lambda: false
              },
              organization: {
                has_lambda: false
              }
            },
            has_many: {
              payment_methods: {
                through: "user",
                class_name: "Billing::PaymentMethod",
                has_lambda: false
              },
              membership_groups: {
                has_lambda: false
              },
              groups: {
                through: "membership_groups",
                has_lambda: false
              }
            }
          },
          "Notes::NoteModel": {
            has_many: {
              attachments: {
                has_lambda: false
              },
              involvements: {
                has_lambda: false
              },
              users: {
                through: "involvements",
                class_name: "Users::User",
                has_lambda: false
              }
            },
            belongs_to: {
              organization: {
                class_name: "Organizations::Organization",
                has_lambda: false
              },
              author: {
                class_name: "Users::User",
                has_lambda: false
              },
              phone_conversation: {
                class_name: "Communication::PhoneConversation",
                has_lambda: false
              },
              text_message: {
                class_name: "Communication::TextMessages::TextMessage",
                has_lambda: false
              },
              email: {
                class_name: "Communication::Emails::Email",
                has_lambda: false
              },
              participation: {
                class_name: "Communication::Participations::Participation",
                has_lambda: false
              }
            }
          },
          "Studios::OccasionModel": {
            has_many: {
              bookings: {
                has_lambda: false
              },
              slots: {
                has_lambda: false
              },
              schedule_dates: {
                has_lambda: false
              }
            }
          },
          "Organizations::OrganizationModel": {
            has_many: {
              memberships: {
                has_lambda: true
              },
              users: {
                through: "memberships",
                has_lambda: false
              },
              projects: {
                through: "users",
                class_name: "Projects::Project",
                has_lambda: false
              },
              payment_methods: {
                through: "memberships",
                class_name: "Billing::PaymentMethod",
                has_lambda: false
              },
              health_records: {
                class_name: "Users::HealthRecord",
                has_lambda: false
              },
              learning_styles: {
                class_name: "Users::LearningStyle",
                has_lambda: false
              },
              ownerships: {
                has_lambda: true
              },
              owners: {
                through: "ownerships",
                source: "user",
                class_name: "Users::User",
                has_lambda: false
              },
              instructorships: {
                has_lambda: true
              },
              instructors: {
                through: "instructorships",
                source: "user",
                class_name: "Users::User",
                has_lambda: false
              },
              studentships: {
                has_lambda: true
              },
              students: {
                through: "studentships",
                source: "user",
                class_name: "Users::User",
                has_lambda: false
              },
              pickupships: {
                has_lambda: true
              },
              pickups: {
                through: "pickupships",
                source: "user",
                class_name: "Users::User",
                has_lambda: false
              },
              attendships: {
                has_lambda: true
              },
              attends: {
                through: "attendships",
                source: "user",
                class_name: "Users::User",
                has_lambda: false
              },
              membership_requests: {
                class_name: "Membership",
                has_lambda: true
              },
              invited_users: {
                through: "membership_requests",
                source: "user",
                class_name: "Users::User",
                has_lambda: false
              },
              ownership_requests: {
                class_name: "Ownership",
                has_lambda: true
              },
              invited_owners: {
                through: "ownership_requests",
                source: "user",
                class_name: "Users::User",
                has_lambda: false
              },
              instructorship_requests: {
                class_name: "Instructorship",
                has_lambda: true
              },
              invited_instructors: {
                through: "instructorship_requests",
                source: "user",
                class_name: "Users::User",
                has_lambda: false
              },
              studentship_requests: {
                class_name: "Studentship",
                has_lambda: true
              },
              invited_students: {
                through: "studentship_requests",
                source: "user",
                class_name: "Users::User",
                has_lambda: false
              },
              groups: {
                has_lambda: false
              },
              emergency_contacts: {
                has_lambda: false
              },
              phone_numbers: {
                has_lambda: false
              },
              addresses: {
                has_lambda: false
              },
              user_phone_numbers: {
                class_name: "Users::PhoneNumber",
                has_lambda: false
              },
              user_addresses: {
                class_name: "Users::Address",
                has_lambda: false
              },
              notes: {
                class_name: "Notes::Note",
                has_lambda: false
              },
              leads: {
                class_name: "Leads::Lead",
                has_lambda: false
              },
              bookings: {
                class_name: "Studios::Booking",
                has_lambda: false
              },
              participations: {
                through: "bookings",
                class_name: "Communication::Participations::Child",
                has_lambda: false
              },
              booking_instances: {
                class_name: "Studios::BookingInstance",
                has_lambda: false
              },
              registrations: {
                class_name: "Streaming::Registration",
                has_lambda: false
              },
              viewers: {
                class_name: "Streaming::Viewer",
                has_lambda: false
              },
              executed_contracts: {
                class_name: "Contracts::Execution",
                has_lambda: false
              },
              subscriptions: {
                class_name: "Billing::Subscription",
                has_lambda: false
              },
              credits: {
                class_name: "Billing::Credits::Credit",
                has_lambda: false
              },
              invoices: {
                class_name: "Billing::Invoice",
                has_lambda: false
              },
              oauth_applications: {
                class_name: "Doorkeeper::Application",
                as: "owner",
                has_lambda: false
              },
              active_subscription_members: {
                class_name: "Studios::Booking",
                has_lambda: true
              },
              opportunities: {
                class_name: "Opportunities::Opportunity",
                has_lambda: false
              },
              tasks: {
                class_name: "Leads::Task",
                has_lambda: false
              },
              assignments: {
                through: "opportunities",
                class_name: "Opportunities::Assignments::Assignment",
                has_lambda: false
              }
            },
            belongs_to: {
              location: {
                class_name: "Studios::Location",
                has_lambda: false
              },
              referred_by: {
                class_name: "Users::User",
                has_lambda: false
              },
              duplicate_of: {
                class_name: "Organizations::Organization",
                has_lambda: false
              }
            }
          },
          "Users::UserModel": {
            has_many: {
              log_entries: {
                as: "referencing",
                class_name: "Logging::LogEntry",
                has_lambda: false
              },
              invitations: {
                class_name: "::Organizations::Membership",
                has_lambda: true
              },
              memberships: {
                class_name: "::Organizations::Membership",
                has_lambda: true
              },
              ownerships: {
                class_name: "::Organizations::Ownership",
                has_lambda: true
              },
              instructorships: {
                class_name: "::Organizations::Instructorship",
                has_lambda: true
              },
              studentships: {
                class_name: "::Organizations::Studentship",
                has_lambda: true
              },
              pickupships: {
                class_name: "::Organizations::Pickupship",
                has_lambda: true
              },
              attendships: {
                class_name: "::Organizations::Attendship",
                has_lambda: true
              },
              organizations: {
                through: "memberships",
                class_name: "::Organizations::Organization",
                has_lambda: false
              },
              organizations_owned: {
                through: "ownerships",
                class_name: "::Organizations::Organization",
                source: "organization",
                has_lambda: true
              },
              membership_groups: {
                through: "memberships",
                has_lambda: false
              },
              groups: {
                through: "membership_groups",
                has_lambda: false
              },
              sessions: {
                has_lambda: false
              },
              password_resets: {
                has_lambda: false
              },
              team_memberships: {
                class_name: "Staff::TeamMembership",
                has_lambda: false
              },
              teams: {
                through: "team_memberships",
                class_name: "Staff::Team",
                has_lambda: false
              },
              friend_requests: {
                class_name: "Friends::FriendRequest",
                has_lambda: false
              },
              friendships: {
                class_name: "Friends::Friendship",
                has_lambda: false
              },
              friends: {
                through: "friendships",
                source: "friend",
                class_name: "Users::User",
                has_lambda: false
              },
              followings: {
                class_name: "Friends::Following",
                has_lambda: false
              },
              followers: {
                class_name: "Friends::Following",
                foreign_key: "following_id",
                has_lambda: false
              },
              user_activities: {
                class_name: "Stream::UserActivities::UserActivity",
                has_lambda: false
              },
              chat_messages: {
                class_name: "Streaming::ChatMessage",
                has_lambda: false
              },
              keyring_grants: {
                class_name: "Library::KeyringGrant",
                has_lambda: false
              },
              viewers: {
                class_name: "Streaming::Viewer",
                has_lambda: false
              },
              subscription_deposits: {
                class_name: "Economy::SubscriptionDeposit",
                has_lambda: false
              },
              nrdy_membership_deposits: {
                class_name: "Economy::NrdyMembershipDeposit",
                has_lambda: false
              },
              bank_balance_adjustments: {
                class_name: "Economy::BankBalanceAdjustment",
                has_lambda: false
              },
              keyring_purchases: {
                class_name: "Economy::KeyringPurchase",
                has_lambda: false
              },
              ledgers: {
                class_name: "Economy::Ledger",
                has_lambda: false
              },
              guide_preferences: {
                class_name: "Guides::Preference",
                has_lambda: false
              },
              preferred_guides: {
                through: "guide_preferences",
                source: "guide",
                class_name: "Users::User",
                has_lambda: false
              },
              guide_blocks: {
                class_name: "Guides::Block",
                has_lambda: false
              },
              guides_blocked: {
                through: "guide_blocks",
                class_name: "Users::User",
                has_lambda: false
              },
              schedulables: {
                class_name: "Guides::Schedulable",
                has_lambda: false
              },
              schedulable_occasions: {
                through: "schedulables",
                class_name: "Studios::Occasion",
                has_lambda: false
              },
              availabilities: {
                class_name: "Guides::Availability",
                has_lambda: false
              },
              earnings: {
                class_name: "Guides::Earnings::Earning",
                has_lambda: false
              },
              subscriptions: {
                through: "organizations",
                has_lambda: false
              },
              payment_methods: {
                class_name: "Billing::PaymentMethod",
                has_lambda: false
              },
              version_stars: {
                class_name: "Projects::VersionStar",
                has_lambda: false
              },
              version_flags: {
                class_name: "Projects::VersionFlag",
                has_lambda: false
              },
              projects: {
                class_name: "::Projects::Project",
                has_lambda: false
              },
              revisions: {
                class_name: "::Projects::Revision",
                has_lambda: false
              },
              project_revisions: {
                class_name: "::Projects::Revision",
                has_lambda: false
              },
              shares: {
                class_name: "::Projects::Share",
                has_lambda: false
              },
              project_statistics: {
                has_lambda: false
              },
              public_apps: {
                class_name: "Projects::PublicApp",
                has_lambda: false
              },
              statistics: {
                class_name: "Analytics::UserStatistic",
                has_lambda: false
              },
              public_sessions: {
                class_name: "Marketing::PublicSession",
                has_lambda: false
              },
              incident_involvements: {
                class_name: "::Incidents::Involvement",
                has_lambda: false
              },
              incidents: {
                through: "incident_involvements",
                class_name: "::Incidents::Incident",
                has_lambda: false
              },
              bookings: {
                class_name: "Studios::Booking",
                has_lambda: false
              },
              booking_instances: {
                class_name: "Studios::BookingInstance",
                has_lambda: false
              },
              note_involvements: {
                class_name: "::Notes::Involvement",
                has_lambda: false
              },
              notes: {
                class_name: "::Notes::Note",
                through: "note_involvements",
                has_lambda: false
              },
              progresses: {
                class_name: "Curriculum::Progress",
                has_lambda: false
              },
              mission_achievements: {
                class_name: "::Curriculum::MissionAchievement",
                has_lambda: false
              },
              missions: {
                through: "mission_achievements",
                class_name: "::Curriculum::Missions::Mission",
                has_lambda: false
              },
              badge_achievements: {
                class_name: "::Curriculum::BadgeAchievement",
                has_lambda: false
              },
              badges: {
                through: "badge_achievements",
                class_name: "::Curriculum::Badge",
                has_lambda: false
              },
              accomplishments: {
                class_name: "::Curriculum::Accomplishment",
                has_lambda: false
              },
              activities: {
                through: "accomplishments",
                class_name: "::Curriculum::Activities::Activity",
                has_lambda: false
              },
              scores: {
                class_name: "Curriculum::Score",
                has_lambda: false
              },
              participations: {
                class_name: "::Communication::Participations::Participation",
                has_lambda: false
              },
              meetings: {
                through: "participations",
                class_name: "::Communication::Meeting",
                has_lambda: false
              },
              employee_reviews: {
                class_name: "::Staff::EmployeeReview",
                foreign_key: "employee_id",
                has_lambda: false
              },
              checklist_submissions: {
                class_name: "::Checklists::Submission",
                has_lambda: false
              },
              phone_numbers: {
                has_lambda: false
              },
              learning_styles: {
                class_name: "Users::LearningStyle",
                has_lambda: false
              },
              addresses: {
                has_lambda: false
              },
              health_records: {
                class_name: "Users::HealthRecord",
                has_lambda: false
              }
            },
            has_one: {
              bank_balance: {
                class_name: "Economy::BankBalance",
                has_lambda: false
              },
              guide_rating: {
                class_name: "Guides::Rating",
                has_lambda: false
              },
              guide_profile: {
                class_name: "Guides::Profile",
                has_lambda: false
              },
              stripe_account: {
                class_name: "Guides::StripeAccount",
                has_lambda: false
              },
              checkr_account: {
                class_name: "Guides::CheckrAccount",
                has_lambda: false
              },
              statistics: {
                has_lambda: false
              },
              first_public_session: {
                class_name: "Marketing::PublicSession",
                has_lambda: true
              },
              last_public_session: {
                class_name: "Marketing::PublicSession",
                has_lambda: true
              },
              user_rank: {
                class_name: "Curriculum::UserRank",
                has_lambda: false
              },
              rank: {
                through: "user_rank",
                class_name: "Curriculum::Rank",
                has_lambda: false
              },
              guide_rank: {
                through: "user_rank",
                class_name: "Curriculum::GuideRank",
                has_lambda: false
              },
              phone: {
                class_name: "Communication::Phone",
                has_lambda: false
              }
            },
            belongs_to: {
              avatar: {
                has_lambda: false
              },
              duplicate_of: {
                class_name: "Users::User",
                has_lambda: false
              },
              how_heard_about: {
                has_lambda: false
              }
            }
          },
          "Billing::Credits::CreditModel": {
            belongs_to: {
              organization: {
                class_name: "Organizations::Organization",
                has_lambda: false
              },
              subscription: {
                class_name: "Billing::Subscription",
                has_lambda: false
              },
              participation: {
                class_name: "Communication::Participations::Participation",
                has_lambda: false
              }
            }
          },
          "Communication::PhoneCalls::PhoneCallModel": {
            belongs_to: {
              to_phone: {
                class_name: "Communication::Phone",
                has_lambda: false
              },
              from_phone: {
                class_name: "Communication::Phone",
                has_lambda: false
              },
              call_queue: {
                class_name: "Communication::CallQueue",
                has_lambda: false
              },
              handled_by: {
                class_name: "Users::User",
                has_lambda: false
              },
              claimed_by: {
                class_name: "Users::User",
                has_lambda: false
              },
              team: {
                class_name: "Staff::Team",
                has_lambda: false
              }
            },
            has_many: {
              conversations_started: {
                class_name: "Communication::PhoneConversation",
                foreign_key: "phone_call_id",
                has_lambda: false
              },
              conversations_joined: {
                class_name: "Communication::PhoneConversation",
                foreign_key: "destination_phone_call_id",
                has_lambda: false
              },
              notes: {
                class_name: "Notes::Note",
                has_lambda: false
              }
            }
          },
          "Projects::ProjectModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              category: {
                has_lambda: false
              }
            },
            has_many: {
              statistics: {
                class_name: "Analytics::ProjectStatistic",
                has_lambda: false
              },
              shares: {
                has_lambda: false
              },
              versions: {
                has_lambda: false
              },
              version_stars: {
                has_lambda: false
              },
              version_flags: {
                has_lambda: false
              },
              version_emojis: {
                has_lambda: false
              },
              version_comments: {
                has_lambda: false
              },
              documents: {
                has_lambda: false
              },
              leaderboard_scores: {
                class_name: "Players::LeaderboardScore",
                has_lambda: false
              }
            },
            has_one: {
              document: {
                has_lambda: true
              },
              mission_achievement: {
                class_name: "Curriculum::MissionAchievement",
                has_lambda: false
              },
              mission: {
                through: "mission_achievement",
                has_lambda: false
              }
            }
          },
          "Curriculum::Steps::StepModel": {
            belongs_to: {
              tutorial: {
                has_lambda: false
              }
            },
            has_one: {
              difficulty: {
                through: "tutorial",
                has_lambda: false
              },
              course: {
                through: "difficulty",
                has_lambda: false
              }
            },
            has_many: {
              progresses: {
                has_lambda: false
              },
              projects: {
                through: "progresses",
                class_name: "Projects::Project",
                has_lambda: false
              },
              statistics: {
                class_name: "Analytics::StepStatistic",
                has_lambda: false
              }
            }
          },
          "Billing::SubscriptionModel": {
            belongs_to: {
              organization: {
                class_name: "Organizations::Organization",
                has_lambda: false
              },
              location: {
                class_name: "Studios::Location",
                has_lambda: false
              },
              payment_method: {
                has_lambda: false
              },
              merchant_account: {
                has_lambda: false
              },
              author: {
                class_name: "Users::User",
                has_lambda: false
              }
            },
            has_many: {
              log_entries: {
                as: "referencing",
                class_name: "Logging::LogEntry",
                has_lambda: false
              },
              bookings: {
                class_name: "Studios::Booking",
                has_lambda: false
              },
              invoice_subscription_prepayments: {
                has_lambda: false
              },
              subscription_discounts: {
                class_name: "Billing::SubscriptionDiscounts::SubscriptionDiscount",
                has_lambda: false
              },
              subscription_add_ons: {
                class_name: "Billing::SubscriptionAddOns::SubscriptionAddOn",
                has_lambda: false
              }
            },
            has_one: {
              studio_add_on: {
                class_name: "Billing::SubscriptionAddOns::Studio",
                has_lambda: false
              },
              explorer_add_on: {
                class_name: "Billing::SubscriptionAddOns::Explorer",
                has_lambda: false
              },
              saas_add_on: {
                class_name: "Billing::SubscriptionAddOns::Saas",
                has_lambda: false
              },
              nova_add_on: {
                class_name: "Billing::SubscriptionAddOns::Nova",
                has_lambda: false
              },
              supernova_starter_add_on: {
                class_name: "Billing::SubscriptionAddOns::SupernovaStarter",
                has_lambda: false
              },
              supernova_lite_add_on: {
                class_name: "Billing::SubscriptionAddOns::SupernovaLite",
                has_lambda: false
              },
              supernova_add_on: {
                class_name: "Billing::SubscriptionAddOns::Supernova",
                has_lambda: false
              },
              supernova_pro_add_on: {
                class_name: "Billing::SubscriptionAddOns::SupernovaPro",
                has_lambda: false
              }
            }
          },
          "Billing::SubscriptionDiscounts::SubscriptionDiscountModel": {
            belongs_to: {
              subscription: {
                class_name: "Billing::Subscription",
                has_lambda: false
              },
              coupon: {
                has_lambda: false
              }
            },
            has_one: {
              organization: {
                through: "subscription",
                class_name: "Organizations::Organization",
                has_lambda: false
              }
            }
          },
          "Communication::TextMessages::TextMessageModel": {
            has_many: {
              text_message_attachments: {
                has_lambda: false
              },
              notes: {
                class_name: "Notes::Note",
                has_lambda: false
              }
            },
            has_one: {
              note: {
                class_name: "Notes::Note",
                has_lambda: false
              }
            },
            belongs_to: {
              sender: {
                class_name: "Users::User",
                has_lambda: false
              },
              handled_by: {
                class_name: "Users::User",
                has_lambda: false
              },
              claimed_by: {
                class_name: "Users::User",
                has_lambda: false
              },
              booking: {
                class_name: "Studios::Booking",
                has_lambda: false
              },
              attendance: {
                class_name: "Studios::Attendance",
                has_lambda: false
              },
              share: {
                class_name: "Projects::Share",
                has_lambda: false
              },
              team: {
                class_name: "Staff::Team",
                has_lambda: false
              }
            }
          },
          "Projects::VersionModel": {
            has_many: {
              shares: {
                has_lambda: false
              },
              version_status_changes: {
                has_lambda: false
              },
              version_stars: {
                has_lambda: false
              },
              version_flags: {
                has_lambda: false
              },
              version_emojis: {
                has_lambda: false
              },
              version_comments: {
                has_lambda: false
              },
              leaderboard_scores: {
                class_name: "Players::LeaderboardScore",
                has_lambda: false
              }
            },
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              step: {
                class_name: "Curriculum::Steps::Step",
                has_lambda: false
              },
              mission_step: {
                class_name: "Curriculum::MissionSteps::MissionStep",
                has_lambda: false
              },
              project: {
                has_lambda: false
              },
              category: {
                has_lambda: false
              }
            }
          },
          "Curriculum::BadgeModel": {
            has_many: {
              badge_dependent_badges: {
                has_lambda: false
              },
              dependent_badges: {
                through: "badge_dependent_badges",
                class_name: "Badge",
                has_lambda: false
              },
              badge_skills: {
                has_lambda: false
              },
              skills: {
                through: "badge_skills",
                class_name: "Skill",
                has_lambda: false
              },
              badge_conditions: {
                has_lambda: false
              },
              badge_achievements: {
                has_lambda: false
              },
              badges_in_series: {
                foreign_key: "first_badge_id",
                primary_key: "first_badge_id",
                class_name: "Badge",
                has_lambda: false
              }
            },
            belongs_to: {
              previous_badge: {
                class_name: "Badge",
                has_lambda: false
              },
              first_badge: {
                class_name: "Badge",
                has_lambda: false
              },
              keyring: {
                class_name: "Library::Keyring",
                has_lambda: false
              }
            },
            has_one: {
              badge_summary: {
                has_lambda: false
              }
            }
          },
          "Billing::CouponSubscriptionDiscounts::CouponSubscriptionDiscountModel": {
            belongs_to: {
              coupon: {
                has_lambda: false
              }
            }
          },
          "Curriculum::Activities::ActivityModel": {
            belongs_to: {
              mission: {
                class_name: "Curriculum::Missions::Mission",
                has_lambda: false
              }
            },
            has_many: {
              activity_skills: {
                has_lambda: false
              },
              skills: {
                through: "activity_skills",
                has_lambda: false
              },
              accomplishments: {
                has_lambda: false
              }
            }
          },
          "Curriculum::LearningPathLevelModel": {
            belongs_to: {
              learning_path: {
                has_lambda: false
              }
            },
            has_many: {
              learning_path_level_skill_levels: {
                has_lambda: false
              }
            },
            has_one: {
              learning_path_level_summary: {
                has_lambda: false
              }
            }
          },
          "Library::EngineVersionModel": {
            belongs_to: {
              engine: {
                has_lambda: false
              },
              publisher: {
                class_name: "Users::User",
                has_lambda: false
              },
              extends_engine_version: {
                class_name: "EngineVersion",
                has_lambda: false
              }
            },
            has_one: {
              source_engine_version: {
                class_name: "EngineVersion",
                has_lambda: false
              }
            },
            has_many: {
              engine_module_versions: {
                has_lambda: false
              },
              engine_modules: {
                through: "engine_module_versions",
                has_lambda: false
              },
              engine_configuration_template_versions: {
                has_lambda: false
              },
              engine_configuration_templates: {
                through: "engine_configuration_template_versions",
                has_lambda: false
              },
              engine_method_versions: {
                has_lambda: false
              },
              engine_methods: {
                through: "engine_method_versions",
                has_lambda: false
              },
              engine_event_versions: {
                has_lambda: false
              },
              engine_events: {
                through: "engine_event_versions",
                has_lambda: false
              },
              object_versions: {
                has_lambda: false
              },
              objects: {
                through: "object_versions",
                has_lambda: false
              }
            }
          },
          "Curriculum::MissionObjects::MissionObjectModel": {
            belongs_to: {
              mission: {
                class_name: "Curriculum::Missions::Mission",
                has_lambda: false
              },
              object: {
                class_name: "Library::Object",
                has_lambda: false
              }
            }
          },
          "Curriculum::Missions::MissionModel": {
            has_many: {
              activities: {
                class_name: "Curriculum::Activities::Activity",
                has_lambda: false
              },
              mission_skills: {
                has_lambda: false
              },
              skills: {
                through: "mission_skills",
                has_lambda: false
              },
              mission_objects: {
                class_name: "Curriculum::MissionObjects::MissionObject",
                has_lambda: false
              },
              objects: {
                through: "mission_objects",
                class_name: "Library::Object",
                has_lambda: false
              },
              mission_steps: {
                class_name: "Curriculum::MissionSteps::MissionStep",
                has_lambda: false
              },
              multiple_choices: {
                through: "mission_steps",
                has_lambda: false
              },
              correct_multiple_choice_answers: {
                through: "multiple_choices",
                has_lambda: true
              },
              mission_achievements: {
                has_lambda: false
              }
            },
            belongs_to: {
              keyring: {
                class_name: "Library::Keyring",
                has_lambda: false
              }
            }
          },
          "Billing::SubscriptionAddOns::SubscriptionAddOnModel": {
            belongs_to: {
              subscription: {
                has_lambda: false
              }
            }
          },
          "Curriculum::BadgeConditionModel": {
            belongs_to: {
              badge: {
                has_lambda: false
              },
              badge_condition: {
                has_lambda: false
              }
            },
            has_many: {
              badge_conditions: {
                has_lambda: false
              },
              badge_comparables: {
                has_lambda: false
              }
            }
          },
          "Curriculum::RankModel": {
            has_many: {
              rank_learning_path_levels: {
                has_lambda: false
              }
            },
            has_one: {
              rank_summary: {
                has_lambda: false
              }
            }
          },
          "Curriculum::MissionSteps::MissionStepModel": {
            belongs_to: {
              mission: {
                class_name: "Missions::Standard",
                has_lambda: false
              }
            },
            has_many: {
              mission_step_tips: {
                has_lambda: false
              },
              mission_step_insertables: {
                has_lambda: false
              },
              multiple_choices: {
                has_lambda: false
              },
              mission_achievements: {
                has_lambda: false
              },
              projects: {
                through: "mission_achievements",
                class_name: "Projects::Project",
                has_lambda: false
              }
            }
          },
          "Curriculum::SkillLevelModel": {
            belongs_to: {
              skill: {
                has_lambda: false
              }
            },
            has_one: {
              skill_level_summary: {
                has_lambda: false
              }
            }
          },
          "Curriculum::MissionStepInsertableModel": {
            belongs_to: {
              mission_step: {
                class_name: "MissionSteps::MissionStep",
                has_lambda: false
              }
            }
          },
          "Communication::MeetingModel": {
            has_many: {
              meeting_status_log_entry: {
                has_lambda: false
              },
              participations: {
                class_name: "Communication::Participations::Participation",
                has_lambda: false
              },
              child_participations: {
                class_name: "Communication::Participations::Child",
                has_lambda: false
              },
              active_child_participations: {
                class_name: "Communication::Participations::Child",
                has_lambda: true
              },
              participating_children: {
                class_name: "Users::User",
                through: "active_child_participations",
                source: "user",
                has_lambda: false
              }
            },
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              occasion: {
                class_name: "Studios::Occasion",
                has_lambda: false
              },
              availability_instance: {
                class_name: "Guides::AvailabilityInstance",
                has_lambda: false
              }
            },
            has_one: {
              guide_profile: {
                through: "user",
                class_name: "Guides::Profile",
                has_lambda: false
              },
              guide_participation: {
                class_name: "Communication::Participations::Guide",
                has_lambda: false
              }
            }
          },
          "Communication::Participations::ParticipationModel": {
            belongs_to: {
              meeting: {
                has_lambda: false
              },
              booking_instance: {
                class_name: "Studios::BookingInstance",
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              booking: {
                class_name: "Studios::Booking",
                has_lambda: false
              }
            },
            has_many: {
              guide_preferences: {
                through: "user",
                has_lambda: false
              }
            },
            has_one: {
              organization: {
                through: "booking",
                has_lambda: false
              },
              occasion: {
                through: "meeting",
                has_lambda: false
              }
            }
          },
          "Curriculum::MultipleChoiceModel": {
            belongs_to: {
              mission_step: {
                class_name: "MissionSteps::MissionStep",
                has_lambda: false
              }
            }
          },
          "Curriculum::MultipleChoiceAnswerModel": {
            belongs_to: {
              multiple_choice: {
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Curriculum::GuideRankModel": {
            has_many: {
              guide_rank_learning_path_levels: {
                has_lambda: false
              }
            },
            has_one: {
              guide_rank_summary: {
                has_lambda: false
              }
            }
          },
          "Opportunities::Assignments::AssignmentModel": {
            belongs_to: {
              opportunity: {
                has_lambda: false
              },
              team: {
                class_name: "Staff::Team",
                has_lambda: false
              },
              owner: {
                class_name: "Users::User",
                has_lambda: false
              },
              resolver: {
                class_name: "Users::User",
                has_lambda: false
              },
              assignor: {
                class_name: "Users::User",
                has_lambda: false
              }
            },
            has_one: {
              organization: {
                through: "opportunity",
                has_lambda: false
              }
            }
          },
          "Streaming::StreamModel": {
            belongs_to: {
              presenter: {
                class_name: "Users::User",
                has_lambda: false
              },
              replay_chat_stream: {
                class_name: "Streaming::Stream",
                has_lambda: false
              }
            },
            has_many: {
              viewers: {
                has_lambda: false
              },
              registrations: {
                has_lambda: false
              },
              chat_messages: {
                has_lambda: false
              }
            }
          },
          "Streaming::ViewerModel": {
            belongs_to: {
              stream: {
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              organization: {
                class_name: "Organizations::Organization",
                has_lambda: false
              }
            }
          },
          "Streaming::ChatMessageModel": {
            belongs_to: {
              stream: {
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              source_chat_message: {
                class_name: "Streaming::ChatMessage",
                has_lambda: false
              }
            },
            has_many: {
              chat_message_approvals: {
                has_lambda: false
              }
            }
          },
          "Streaming::ChatMessageApprovalModel": {
            belongs_to: {
              chat_message: {
                has_lambda: false
              },
              reviewer: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Organizations::GroupModel": {
            belongs_to: {
              organization: {
                has_lambda: false
              }
            },
            has_many: {
              membership_groups: {
                class_name: "MembershipGroup",
                has_lambda: false
              },
              memberships: {
                through: "membership_groups",
                has_lambda: false
              },
              users: {
                through: "memberships",
                has_lambda: false
              }
            }
          },
          "Organizations::MembershipGroupModel": {
            belongs_to: {
              membership: {
                class_name: "Membership",
                has_lambda: false
              },
              group: {
                class_name: "Group",
                has_lambda: false
              }
            }
          },
          "Studios::LocationModel": {
            has_many: {
              bookings: {
                has_lambda: false
              },
              attendances: {
                through: "bookings",
                has_lambda: false
              },
              slots: {
                has_lambda: false
              },
              leads: {
                class_name: "Leads::Lead",
                has_lambda: false
              },
              certificates: {
                has_lambda: false
              },
              hardware_components: {
                class_name: "Hardware::Components::Component",
                has_lambda: false
              },
              incidents: {
                class_name: "Incidents::Incident",
                has_lambda: false
              }
            },
            belongs_to: {
              merchant_account: {
                class_name: "Billing::MerchantAccount",
                has_lambda: false
              }
            }
          },
          "Studios::SlotModel": {
            belongs_to: {
              location: {
                has_lambda: false
              },
              occasion: {
                has_lambda: false
              }
            }
          },
          "Leads::LeadInterestModel": {
            belongs_to: {
              lead: {
                has_lambda: false
              },
              interest: {
                has_lambda: false
              }
            }
          },
          "Billing::MerchantAccountModel": {
            has_many: {
              invoices: {
                has_lambda: false
              },
              subscriptions: {
                has_lambda: false
              },
              locations: {
                class_name: "Studios::Locations",
                has_lambda: false
              }
            }
          },
          "Billing::PaymentMethodModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            },
            has_many: {
              invoices: {
                has_lambda: false
              },
              subscriptions: {
                has_lambda: false
              },
              charges: {
                has_lambda: false
              }
            }
          },
          "Billing::InvoiceSubscriptionPrepaymentModel": {
            belongs_to: {
              subscription: {
                class_name: "Billing::Subscription",
                has_lambda: false
              },
              invoice: {
                has_lambda: false
              }
            },
            has_one: {
              organization: {
                through: "invoice",
                has_lambda: false
              }
            }
          },
          "Billing::InvoiceModel": {
            belongs_to: {
              merchant_account: {
                has_lambda: false
              },
              payment_method: {
                has_lambda: false
              },
              organization: {
                class_name: "Organizations::Organization",
                has_lambda: false
              }
            },
            has_many: {
              charges: {
                class_name: "Billing::InvoiceCharge",
                has_lambda: false
              },
              invoice_subscription_prepayments: {
                has_lambda: false
              },
              bookings: {
                through: "invoice_bookings",
                class_name: "Studios::Booking",
                has_lambda: false
              },
              invoice_bookings: {
                class_name: "InvoiceBookings::InvoiceBooking",
                has_lambda: false
              },
              invoice_deposit_bookings: {
                class_name: "InvoiceBookings::Deposit",
                has_lambda: false
              },
              invoice_balance_bookings: {
                class_name: "InvoiceBookings::Balance",
                has_lambda: false
              },
              booking_balance_invoice_bookings: {
                through: "invoice_bookings",
                class_name: "InvoiceBookings::Balance",
                has_lambda: false
              },
              invoice_coupons: {
                has_lambda: false
              },
              coupons: {
                through: "invoice_coupons",
                has_lambda: false
              },
              invoice_product_purchases: {
                has_lambda: false
              },
              invoice_product_returns: {
                has_lambda: false
              },
              invoice_vouchers: {
                has_lambda: false
              }
            }
          },
          "Billing::InvoiceCouponModel": {
            belongs_to: {
              coupon: {
                has_lambda: false
              },
              invoice: {
                has_lambda: false
              }
            },
            has_one: {
              organization: {
                through: "invoice",
                has_lambda: false
              }
            }
          },
          "Billing::CouponModel": {
            has_many: {
              invoice_coupons: {
                has_lambda: false
              },
              invoices: {
                through: "invoice_coupons",
                has_lambda: false
              },
              coupon_occasions: {
                has_lambda: false
              },
              occasions: {
                through: "coupon_occasions",
                has_lambda: false
              },
              coupon_subscription_discounts: {
                class_name: "Billing::CouponSubscriptionDiscounts::CouponSubscriptionDiscount",
                has_lambda: false
              },
              subscription_discounts: {
                class_name: "Billing::SubscriptionDiscounts::SubscriptionDiscount",
                has_lambda: false
              }
            },
            belongs_to: {
              ambassador: {
                class_name: "Users::User",
                has_lambda: false
              }
            },
            has_one: {
              explorer_coupon_subscription_discount: {
                class_name: "Billing::CouponSubscriptionDiscounts::Explorer",
                has_lambda: true
              },
              studio_coupon_subscription_discount: {
                class_name: "Billing::CouponSubscriptionDiscounts::Studio",
                has_lambda: true
              },
              saas_coupon_subscription_discount: {
                class_name: "Billing::CouponSubscriptionDiscounts::Saas",
                has_lambda: true
              },
              nova_coupon_subscription_discount: {
                class_name: "Billing::CouponSubscriptionDiscounts::Nova",
                has_lambda: true
              },
              supernova_lite_coupon_subscription_discount: {
                class_name: "Billing::CouponSubscriptionDiscounts::SupernovaLite",
                has_lambda: true
              },
              supernova_pro_coupon_subscription_discount: {
                class_name: "Billing::CouponSubscriptionDiscounts::SupernovaPro",
                has_lambda: true
              },
              supernova_starter_coupon_subscription_discount: {
                class_name: "Billing::CouponSubscriptionDiscounts::SupernovaStarter",
                has_lambda: true
              },
              supernova_coupon_subscription_discount: {
                class_name: "Billing::CouponSubscriptionDiscounts::Supernova",
                has_lambda: true
              }
            }
          },
          "Billing::CouponOccasionModel": {
            belongs_to: {
              coupon: {
                has_lambda: false
              },
              occasion: {
                class_name: "Studios::Occasion",
                has_lambda: false
              }
            }
          },
          "Billing::InvoiceProductPurchaseModel": {
            belongs_to: {
              product_sku_trait_value: {
                class_name: "Products::SkuTraitValue",
                has_lambda: false
              },
              invoice: {
                has_lambda: false
              }
            },
            has_one: {
              organization: {
                through: "invoice",
                has_lambda: false
              }
            },
            has_many: {
              invoice_product_purchase_discounts: {
                has_lambda: false
              }
            }
          },
          "Products::SkuTraitValueModel": {
            belongs_to: {
              sku: {
                has_lambda: false
              },
              trait_value: {
                has_lambda: false
              }
            },
            has_many: {
              inventories: {
                has_lambda: false
              }
            },
            has_one: {
              product: {
                through: "sku",
                has_lambda: false
              }
            }
          },
          "Products::TraitValueModel": {
            belongs_to: {
              trait: {
                has_lambda: false
              }
            },
            has_many: {
              sku_trait_value: {
                has_lambda: false
              }
            }
          },
          "Products::TraitModel": {
            has_many: {
              trait_values: {
                has_lambda: false
              }
            }
          },
          "Products::SkuModel": {
            belongs_to: {
              product: {
                has_lambda: false
              }
            },
            has_many: {
              sku_trait_values: {
                has_lambda: false
              },
              trait_values: {
                through: "sku_trait_values",
                has_lambda: false
              }
            }
          },
          "Products::ProductModel": {
            has_many: {
              skus: {
                has_lambda: false
              },
              photos: {
                has_lambda: false
              }
            }
          },
          "Products::PhotoModel": {
            belongs_to: {
              product: {
                has_lambda: false
              }
            }
          },
          "Products::InventoryModel": {
            belongs_to: {
              location: {
                class_name: "Studios::Location",
                has_lambda: false
              },
              sku_trait_value: {
                has_lambda: false
              }
            }
          },
          "Billing::InvoiceProductReturnModel": {
            belongs_to: {
              invoice_product_purchase: {
                has_lambda: false
              },
              invoice: {
                has_lambda: false
              }
            },
            has_one: {
              organization: {
                through: "invoice",
                has_lambda: false
              }
            }
          },
          "Billing::InvoiceVoucherModel": {
            belongs_to: {
              invoice: {
                has_lambda: false
              },
              voucher: {
                has_lambda: false
              }
            },
            has_one: {
              organization: {
                through: "invoice",
                has_lambda: false
              }
            }
          },
          "Billing::VoucherModel": {
            has_many: {
              invoice_vouchers: {
                has_lambda: false
              },
              invoices: {
                through: "invoice_vouchers",
                has_lambda: false
              }
            }
          },
          "Billing::ChargeModel": {
            belongs_to: {
              payment_method: {
                has_lambda: false
              }
            },
            has_many: {
              charge_refunds: {
                has_lambda: false
              }
            }
          },
          "Billing::InvoiceChargeModel": {
            belongs_to: {
              invoice: {
                has_lambda: false
              }
            },
            has_one: {
              organization: {
                through: "invoice",
                has_lambda: false
              }
            }
          },
          "Billing::ChargeRefundModel": {
            belongs_to: {
              charge: {
                has_lambda: false
              }
            }
          },
          "Communication::PhoneConversationModel": {
            belongs_to: {
              phone_call: {
                class_name: "Communication::PhoneCalls::PhoneCall",
                has_lambda: false
              },
              destination_phone_call: {
                class_name: "Communication::PhoneCalls::PhoneCall",
                has_lambda: false
              },
              call_queue: {
                class_name: "Communication::CallQueue",
                has_lambda: false
              }
            },
            has_one: {
              note: {
                class_name: "Notes::Note",
                has_lambda: false
              }
            }
          },
          "Communication::PhoneModel": {
            has_many: {
              outgoing_phone_calls: {
                class_name: "Communication::PhoneCalls::Outbound",
                foreign_key: "from_phone_id",
                has_lambda: false
              },
              incoming_phone_calls: {
                class_name: "Communication::PhoneCalls::Outbound",
                foreign_key: "from_phone_id",
                has_lambda: false
              },
              call_queue_memberships: {
                has_lambda: false
              },
              call_queues: {
                through: "call_queue_memberships",
                has_lambda: false
              }
            },
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              failover_phone_number: {
                class_name: "Users::PhoneNumber",
                has_lambda: false
              },
              location: {
                class_name: "Studios::Location",
                has_lambda: false
              }
            }
          },
          "Users::PhoneNumberModel": {
            belongs_to: {
              organization: {
                class_name: "::Organizations::Organization",
                has_lambda: false
              },
              user: {
                has_lambda: false
              }
            }
          },
          "Communication::CallQueueModel": {
            has_many: {
              call_queue_memberships: {
                has_lambda: false
              },
              undeleted_call_queue_memberships: {
                source: "call_queue_membership",
                class_name: "Communication::CallQueueMembership",
                has_lambda: true
              },
              phones: {
                through: "call_queue_memberships",
                has_lambda: false
              },
              undeleted_phones: {
                through: "undeleted_call_queue_memberships",
                source: "phone",
                class_name: "Communication::Phone",
                has_lambda: true
              },
              phone_calls: {
                class_name: "Communication::PhoneCalls::PhoneCall",
                has_lambda: false
              },
              queue_invitation_phone_calls: {
                class_name: "Communication::PhoneCalls::QueueInvitation",
                has_lambda: false
              }
            }
          },
          "Communication::CallQueueMembershipModel": {
            belongs_to: {
              phone: {
                has_lambda: false
              },
              call_queue: {
                has_lambda: false
              }
            }
          },
          "Staff::TeamModel": {
            belongs_to: {
              location: {
                class_name: "Studios::Location",
                has_lambda: false
              },
              leader: {
                class_name: "Users::User",
                has_lambda: false
              }
            },
            has_many: {
              team_memberships: {
                has_lambda: false
              },
              phone_calls: {
                class_name: "Communication::PhoneCalls::PhoneCall",
                has_lambda: false
              },
              emails: {
                class_name: "Communication::Emails::Email",
                has_lambda: false
              },
              text_messages: {
                class_name: "Communication::TextMessages::TextMessage",
                has_lambda: false
              },
              incident_tasks: {
                class_name: "Incidents::Task",
                has_lambda: false
              },
              lead_tasks: {
                class_name: "Leads::Task",
                has_lambda: false
              }
            }
          },
          "Projects::ShareModel": {
            belongs_to: {
              project: {
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            },
            has_one: {
              text_message: {
                class_name: "Communication::TextMessages::Share",
                has_lambda: false
              }
            }
          },
          "Curriculum::MissionAchievementModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              mission: {
                class_name: "Curriculum::Missions::Mission",
                has_lambda: false
              },
              mission_step: {
                class_name: "Curriculum::MissionSteps::MissionStep",
                has_lambda: false
              },
              project: {
                class_name: "Projects::Project",
                has_lambda: false
              }
            }
          },
          "Library::KeyringModel": {
            has_many: {
              objects: {
                has_lambda: false
              },
              object_methods: {
                has_lambda: false
              },
              object_included_engine_methods: {
                has_lambda: false
              },
              object_method_parameters: {
                has_lambda: false
              },
              object_events: {
                has_lambda: false
              },
              object_included_engine_events: {
                has_lambda: false
              },
              object_event_parameters: {
                has_lambda: false
              },
              object_constant_values: {
                has_lambda: false
              }
            }
          },
          "Library::ObjectModel": {
            has_many: {
              versions: {
                class_name: "Library::ObjectVersion",
                has_lambda: false
              },
              object_versions: {
                has_lambda: false
              },
              object_methods: {
                has_lambda: false
              },
              object_included_engine_methods: {
                has_lambda: false
              },
              object_events: {
                has_lambda: false
              },
              object_included_engine_events: {
                has_lambda: false
              },
              object_constants: {
                has_lambda: false
              },
              object_reactions: {
                through: "unpublished_version",
                has_lambda: false
              },
              object_configuration_templates: {
                through: "unpublished_version",
                has_lambda: false
              },
              object_configuration_values: {
                through: "unpublished_version",
                has_lambda: false
              },
              engine_modules: {
                through: "engine",
                has_lambda: false
              },
              engine_configuration_templates: {
                through: "engine",
                has_lambda: false
              },
              engine_events: {
                through: "engine",
                has_lambda: false
              },
              engine_methods: {
                through: "engine",
                has_lambda: false
              }
            },
            has_one: {
              unpublished_version: {
                class_name: "Library::ObjectVersion",
                has_lambda: true
              },
              current_version: {
                class_name: "ObjectVersion",
                has_lambda: true
              }
            },
            belongs_to: {
              engine: {
                has_lambda: false
              },
              keyring: {
                has_lambda: false
              },
              category: {
                has_lambda: false
              }
            }
          },
          "Library::EngineModel": {
            has_many: {
              engine_versions: {
                has_lambda: false
              },
              engine_methods: {
                has_lambda: false
              },
              engine_events: {
                has_lambda: false
              },
              engine_modules: {
                has_lambda: false
              },
              engine_configuration_templates: {
                has_lambda: false
              },
              engine_configuration_options: {
                through: "engine_configuration_templates",
                has_lambda: false
              },
              objects: {
                has_lambda: false
              },
              versions: {
                class_name: "Library::EngineVersion",
                has_lambda: false
              }
            },
            belongs_to: {
              extends_engine: {
                class_name: "Engine",
                has_lambda: false
              }
            },
            has_one: {
              current_version: {
                class_name: "EngineVersion",
                has_lambda: true
              },
              unpublished_version: {
                class_name: "Library::EngineVersion",
                has_lambda: true
              }
            }
          },
          "Library::EngineMethodModel": {
            has_many: {
              versions: {
                class_name: "Library::EngineMethodVersion",
                has_lambda: false
              },
              engine_method_parameters: {
                has_lambda: false
              },
              engine_method_versions: {
                has_lambda: false
              },
              undeleted_engine_method_versions: {
                class_name: "EngineMethodVersion",
                has_lambda: true
              },
              engine_method_modules: {
                through: "unpublished_version",
                has_lambda: false
              },
              engine_method_tips: {
                through: "unpublished_version",
                has_lambda: false
              }
            },
            has_one: {
              unpublished_version: {
                class_name: "Library::EngineMethodVersion",
                has_lambda: true
              }
            },
            belongs_to: {
              engine: {
                has_lambda: false
              }
            }
          },
          "Library::EngineConfigurationOptionModel": {
            belongs_to: {
              engine_configuration_template: {
                has_lambda: false
              }
            },
            has_one: {
              engine: {
                through: "engine_configuration_template",
                has_lambda: false
              },
              unpublished_version: {
                class_name: "Library::EngineConfigurationOptionVersion",
                has_lambda: true
              }
            },
            has_many: {
              engine_configuration_option_versions: {
                has_lambda: false
              },
              versions: {
                class_name: "Library::EngineConfigurationOptionVersion",
                has_lambda: false
              }
            }
          },
          "Library::EngineConfigurationTemplateModel": {
            belongs_to: {
              engine: {
                has_lambda: false
              }
            },
            has_many: {
              engine_configuration_template_versions: {
                has_lambda: false
              },
              engine_configuration_options: {
                has_lambda: false
              },
              versions: {
                class_name: "Library::EngineConfigurationTemplateVersion",
                has_lambda: false
              }
            },
            has_one: {
              unpublished_version: {
                class_name: "Library::EngineConfigurationTemplateVersion",
                has_lambda: true
              }
            }
          },
          "Library::EngineMethodParameterModel": {
            belongs_to: {
              engine_method: {
                has_lambda: false
              }
            },
            has_one: {
              engine: {
                through: "engine_method",
                has_lambda: false
              },
              unpublished_version: {
                class_name: "Library::EngineMethodParameterVersion",
                has_lambda: true
              }
            },
            has_many: {
              engine_method_parameter_versions: {
                has_lambda: false
              },
              versions: {
                class_name: "Library::EngineMethodParameterVersion",
                has_lambda: false
              }
            }
          },
          "Library::WidgetModel": {
            has_many: {
              object_method_parameters: {
                has_lambda: false
              },
              object_event_parameters: {
                has_lambda: false
              }
            }
          },
          "Library::EngineEventModel": {
            has_many: {
              versions: {
                class_name: "Library::EngineEventVersion",
                has_lambda: false
              },
              engine_event_versions: {
                has_lambda: false
              },
              undeleted_engine_event_versions: {
                class_name: "EngineEventVersion",
                has_lambda: true
              },
              engine_event_parameters: {
                has_lambda: false
              },
              engine_event_modules: {
                through: "unpublished_version",
                has_lambda: false
              },
              engine_event_tips: {
                through: "unpublished_version",
                has_lambda: false
              }
            },
            has_one: {
              unpublished_version: {
                class_name: "Library::EngineEventVersion",
                has_lambda: true
              }
            },
            belongs_to: {
              engine: {
                has_lambda: false
              }
            }
          },
          "Library::EngineEventParameterModel": {
            belongs_to: {
              engine_event: {
                has_lambda: false
              }
            },
            has_one: {
              engine: {
                through: "engine_event",
                has_lambda: false
              },
              unpublished_version: {
                class_name: "Library::EngineEventParameterVersion",
                has_lambda: true
              }
            },
            has_many: {
              engine_event_parameter_versions: {
                has_lambda: false
              },
              versions: {
                class_name: "Library::EngineEventParameterVersion",
                has_lambda: false
              }
            }
          },
          "Library::CategoryModel": {
            has_many: {
              objects: {
                has_lambda: false
              }
            }
          },
          "Library::ObjectEventModel": {
            has_many: {
              versions: {
                class_name: "Library::ObjectEventVersion",
                has_lambda: false
              },
              object_event_versions: {
                has_lambda: false
              },
              object_event_parameters: {
                has_lambda: false
              },
              object_event_modules: {
                through: "unpublished_version",
                has_lambda: false
              },
              object_event_tips: {
                through: "unpublished_version",
                has_lambda: false
              }
            },
            has_one: {
              unpublished_version: {
                class_name: "Library::ObjectEventVersion",
                has_lambda: true
              },
              engine: {
                through: "object",
                has_lambda: false
              }
            },
            belongs_to: {
              object: {
                has_lambda: false
              },
              keyring: {
                has_lambda: false
              }
            }
          },
          "Library::ObjectEventParameterModel": {
            belongs_to: {
              object_event: {
                has_lambda: false
              },
              keyring: {
                has_lambda: false
              }
            },
            has_one: {
              object: {
                through: "object_event",
                has_lambda: false
              },
              unpublished_version: {
                class_name: "Library::ObjectEventParameterVersion",
                has_lambda: true
              }
            },
            has_many: {
              object_event_parameter_versions: {
                has_lambda: false
              },
              versions: {
                class_name: "Library::ObjectEventParameterVersion",
                has_lambda: false
              }
            }
          },
          "Library::ObjectConstantModel": {
            belongs_to: {
              object: {
                has_lambda: false
              }
            },
            has_many: {
              object_constant_versions: {
                has_lambda: false
              },
              object_constant_values: {
                has_lambda: false
              },
              versions: {
                class_name: "Library::ObjectConstantVersion",
                has_lambda: false
              }
            },
            has_one: {
              unpublished_version: {
                class_name: "Library::ObjectConstantVersion",
                has_lambda: true
              }
            }
          },
          "Library::ObjectMethodModel": {
            has_many: {
              versions: {
                class_name: "Library::ObjectMethodVersion",
                has_lambda: false
              },
              object_method_versions: {
                has_lambda: false
              },
              object_method_parameters: {
                has_lambda: false
              },
              object_method_modules: {
                through: "unpublished_version",
                has_lambda: false
              },
              object_method_tips: {
                through: "unpublished_version",
                has_lambda: false
              }
            },
            has_one: {
              unpublished_version: {
                class_name: "Library::ObjectMethodVersion",
                has_lambda: true
              },
              engine: {
                through: "object",
                has_lambda: false
              }
            },
            belongs_to: {
              object: {
                has_lambda: false
              },
              keyring: {
                has_lambda: false
              }
            }
          },
          "Library::ObjectConfigurationValueModel": {
            belongs_to: {
              engine_configuration_option: {
                has_lambda: false
              },
              object_configuration_template: {
                has_lambda: false
              },
              object_constant: {
                has_lambda: false
              }
            }
          },
          "Library::ObjectConfigurationTemplateModel": {
            belongs_to: {
              engine_configuration_template: {
                has_lambda: false
              },
              object_version: {
                has_lambda: false
              },
              source_object_configuration_template: {
                class_name: "ObjectConfigurationTemplate",
                has_lambda: false
              }
            },
            has_many: {
              engine_configuration_options: {
                through: "engine_configuration_template",
                has_lambda: false
              },
              object_configuration_values: {
                has_lambda: false
              },
              undeleted_object_configuration_values: {
                class_name: "ObjectConfigurationValue",
                has_lambda: true
              }
            },
            has_one: {
              engine_version: {
                through: "object_version",
                has_lambda: false
              },
              engine: {
                through: "engine_version",
                has_lambda: false
              }
            }
          },
          "Library::ObjectMethodParameterModel": {
            belongs_to: {
              object_method: {
                has_lambda: false
              },
              keyring: {
                has_lambda: false
              }
            },
            has_one: {
              object: {
                through: "object_method",
                has_lambda: false
              },
              unpublished_version: {
                class_name: "Library::ObjectMethodParameterVersion",
                has_lambda: true
              }
            },
            has_many: {
              object_method_parameter_versions: {
                has_lambda: false
              },
              versions: {
                class_name: "Library::ObjectMethodParameterVersion",
                has_lambda: false
              }
            }
          },
          "Library::ObjectIncludedEngineMethodModel": {
            belongs_to: {
              engine_method: {
                has_lambda: false
              },
              object: {
                has_lambda: false
              },
              keyring: {
                has_lambda: false
              }
            },
            has_one: {
              engine: {
                through: "engine_method",
                has_lambda: false
              },
              unpublished_version: {
                class_name: "Library::ObjectIncludedEngineMethodVersion",
                has_lambda: true
              }
            },
            has_many: {
              versions: {
                class_name: "Library::ObjectIncludedEngineMethodVersion",
                has_lambda: false
              }
            }
          },
          "Library::ObjectIncludedEngineEventModel": {
            belongs_to: {
              engine_event: {
                has_lambda: false
              },
              object: {
                has_lambda: false
              },
              keyring: {
                has_lambda: false
              }
            },
            has_one: {
              engine: {
                through: "engine_event",
                has_lambda: false
              },
              unpublished_version: {
                class_name: "Library::ObjectIncludedEngineEventVersion",
                has_lambda: true
              }
            },
            has_many: {
              versions: {
                class_name: "Library::ObjectIncludedEngineEventVersion",
                has_lambda: false
              }
            }
          },
          "Library::ObjectConstantValueModel": {
            belongs_to: {
              object_constant: {
                has_lambda: false
              },
              keyring: {
                has_lambda: false
              }
            },
            has_one: {
              object: {
                through: "object_constant",
                has_lambda: false
              },
              unpublished_version: {
                class_name: "Library::ObjectConstantValueVersion",
                has_lambda: true
              }
            },
            has_many: {
              object_constant_value_versions: {
                has_lambda: false
              },
              versions: {
                class_name: "Library::ObjectConstantValueVersion",
                has_lambda: false
              }
            }
          },
          "Curriculum::AccomplishmentModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              activity: {
                class_name: "Curriculum::Activities::Activity",
                has_lambda: false
              },
              project: {
                class_name: "Projects::Project",
                has_lambda: false
              }
            }
          },
          "Curriculum::MissionSkillModel": {
            belongs_to: {
              mission: {
                class_name: "Curriculum::Missions::Mission",
                has_lambda: false
              },
              skill: {
                has_lambda: false
              }
            }
          },
          "Curriculum::SkillModel": {
            belongs_to: {
              learning_path: {
                has_lambda: false
              }
            },
            has_many: {
              skill_levels: {
                has_lambda: false
              }
            }
          },
          "Curriculum::LearningPathModel": {
            has_many: {
              learning_path_levels: {
                has_lambda: false
              },
              learning_path_level_summaries: {
                has_lambda: false
              },
              skills: {
                has_lambda: false
              },
              learning_path_skill_levels: {
                has_lambda: false
              }
            }
          },
          "Curriculum::MissionStepTipModel": {
            belongs_to: {
              mission_step: {
                class_name: "MissionSteps::MissionStep",
                has_lambda: false
              }
            }
          },
          "Projects::CategoryModel": {
            has_many: {
              projects: {
                has_lambda: false
              }
            }
          },
          "Projects::DocumentModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              project: {
                has_lambda: false
              },
              current_revision: {
                class_name: "Revision",
                has_lambda: false
              }
            },
            has_many: {
              revisions: {
                has_lambda: false
              }
            }
          },
          "Projects::VersionStarModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              version: {
                class_name: "Projects::Version",
                has_lambda: false
              }
            },
            has_one: {
              project: {
                through: "version",
                class_name: "Projects::Project",
                has_lambda: false
              }
            }
          },
          "Projects::VersionEmojiModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              version: {
                class_name: "Projects::Version",
                has_lambda: false
              }
            },
            has_one: {
              project: {
                through: "version",
                class_name: "Projects::Project",
                has_lambda: false
              }
            }
          },
          "Projects::VersionCommentModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              project: {
                class_name: "Projects::Project",
                has_lambda: false
              },
              version: {
                class_name: "Projects::Version",
                has_lambda: false
              },
              replying_to: {
                class_name: "VersionComment",
                has_lambda: false
              },
              reviewer: {
                class_name: "Users::User",
                has_lambda: false
              }
            },
            has_many: {
              version_comment_flags: {
                has_lambda: false
              },
              version_comment_emojis: {
                has_lambda: false
              }
            }
          },
          "Projects::RevisionModel": {
            has_many: {
              revision_versions: {
                has_lambda: false
              },
              versions: {
                through: "revision_versions",
                has_lambda: false
              }
            },
            belongs_to: {
              document: {
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Projects::VersionStatusChangeModel": {
            belongs_to: {
              version: {
                has_lambda: false
              }
            }
          },
          "Players::LeaderboardScoreModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              project: {
                class_name: "Projects::Project",
                has_lambda: false
              },
              version: {
                class_name: "Projects::Version",
                has_lambda: false
              }
            }
          },
          "Communication::TextMessageAttachmentModel": {
            belongs_to: {
              text_message: {
                class_name: "Communication::TextMessages::TextMessage",
                has_lambda: false
              }
            }
          },
          "Communication::EmailRecipientModel": {
            belongs_to: {
              email: {
                class_name: "Communication::Emails::Email",
                has_lambda: false
              }
            }
          },
          "Communication::EmailAttachmentModel": {
            belongs_to: {
              email: {
                class_name: "Communication::Emails::Email",
                has_lambda: false
              }
            }
          },
          "Notes::InvolvementModel": {
            belongs_to: {
              note: {
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              attendance: {
                class_name: "Studios::Attendance",
                has_lambda: false
              }
            }
          },
          "Notes::AttachmentModel": {
            belongs_to: {
              note: {
                has_lambda: false
              },
              author: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Organizations::AddressModel": {
            belongs_to: {
              organization: {
                has_lambda: false
              }
            }
          },
          "Organizations::PhoneNumberModel": {
            belongs_to: {
              organization: {
                has_lambda: false
              }
            }
          },
          "Users::HealthRecordModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              organization: {
                class_name: "::Organizations::Organization",
                has_lambda: false
              }
            },
            has_many: {
              log_entries: {
                as: "referencing",
                class_name: "Logging::LogEntry",
                has_lambda: false
              }
            }
          },
          "Staff::TeamMembershipModel": {
            belongs_to: {
              team: {
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Friends::FollowingModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              following: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Library::KeyringGrantModel": {
            belongs_to: {
              keyring: {
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              keyring_purchase: {
                class_name: "Economy::KeyringPurchase",
                has_lambda: false
              },
              badge_achievement: {
                class_name: "Curriculum::BadgeAchievement",
                has_lambda: false
              },
              mission_achievement: {
                class_name: "Curriculum::MissionAchievement",
                has_lambda: false
              }
            }
          },
          "Economy::KeyringPurchaseModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              keyring: {
                class_name: "Library::Keyring",
                has_lambda: false
              }
            },
            has_one: {
              keyring_grant: {
                class_name: "Library::KeyringGrant",
                has_lambda: false
              }
            }
          },
          "Curriculum::BadgeAchievementModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              badge: {
                has_lambda: false
              },
              author: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Curriculum::BadgeSkillModel": {
            belongs_to: {
              badge: {
                has_lambda: false
              },
              skill: {
                has_lambda: false
              }
            }
          },
          "Curriculum::BadgeComparableModel": {
            belongs_to: {
              badge_condition: {
                has_lambda: false
              },
              activity: {
                class_name: "Curriculum::Activities::Activity",
                has_lambda: false
              }
            }
          },
          "Economy::SubscriptionDepositModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              subscription: {
                class_name: "Billing::Subscription",
                has_lambda: false
              }
            }
          },
          "Economy::BankBalanceAdjustmentModel": {
            belongs_to: {
              adjusted_by: {
                class_name: "Users::User",
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Economy::LedgerModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              subscription_deposit: {
                has_lambda: false
              },
              keyring_purchase: {
                has_lambda: false
              },
              bank_balance_adjustment: {
                has_lambda: false
              },
              badge_achievement: {
                class_name: "Curriculum::BadgeAchievement",
                has_lambda: false
              },
              accomplishment: {
                class_name: "Curriculum::Accomplishment",
                has_lambda: false
              },
              mission_achievement: {
                class_name: "Curriculum::MissionAchievement",
                has_lambda: false
              }
            }
          },
          "Economy::BankBalanceModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Guides::PreferenceModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              guide: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Guides::BlockModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              guide: {
                class_name: "Users::User",
                has_lambda: false
              },
              author: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Guides::SchedulableModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              occasion: {
                class_name: "Studios::Occasion",
                has_lambda: false
              }
            }
          },
          "Guides::AvailabilityModel": {
            belongs_to: {
              location: {
                class_name: "Studios::Location",
                has_lambda: false
              },
              occasion: {
                class_name: "Studios::Occasion",
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            },
            has_many: {
              log_entries: {
                as: "referencing",
                class_name: "Logging::LogEntry",
                has_lambda: false
              },
              slots: {
                foreign_key: "occasion_id",
                primary_key: "occasion_id",
                has_lambda: true
              },
              overlapping_bookings: {
                foreign_key: "occasion_id",
                primary_key: "occasion_id",
                class_name: "Booking",
                has_lambda: true
              }
            }
          },
          "Guides::Earnings::EarningModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              meeting: {
                class_name: "Communication::Meeting",
                has_lambda: false
              }
            }
          },
          "Guides::RatingModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Guides::ProfileModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Guides::StripeAccountModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Guides::CheckrAccountModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            },
            has_many: {
              background_check_reports: {
                has_lambda: false
              },
              background_check_invitations: {
                has_lambda: false
              }
            }
          },
          "Projects::PublicAppModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Incidents::InvolvementModel": {
            belongs_to: {
              incident: {
                class_name: "Incidents::Incident",
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Incidents::AttachmentModel": {
            belongs_to: {
              incident: {
                has_lambda: false
              },
              author: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Studios::BookingInstanceModel": {
            belongs_to: {
              occasion: {
                has_lambda: false
              },
              booking: {
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              location: {
                has_lambda: false
              },
              availability_instance: {
                class_name: "Guides::AvailabilityInstance",
                has_lambda: false
              },
              slot_instance: {
                has_lambda: false
              },
              organization: {
                class_name: "Organizations::Organization",
                has_lambda: false
              },
              participation: {
                class_name: "Communication::Participations::Participation",
                has_lambda: false
              }
            }
          },
          "Studios::SlotInstanceModel": {
            belongs_to: {
              location: {
                has_lambda: false
              },
              occasion: {
                has_lambda: false
              }
            },
            has_many: {
              availability_instances: {
                has_lambda: false
              }
            }
          },
          "Guides::AvailabilityInstanceModel": {
            belongs_to: {
              occasion: {
                class_name: "Studios::Occasion",
                has_lambda: false
              },
              slot_instance: {
                class_name: "Studios::SlotInstance",
                has_lambda: false
              },
              availability: {
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              guide_rating: {
                class_name: "Guides::Rating",
                foreign_key: "user_id",
                primary_key: "user_id",
                has_lambda: false
              },
              location: {
                class_name: "Studios::Location",
                has_lambda: false
              },
              meeting: {
                class_name: "Communication::Meeting",
                has_lambda: false
              }
            },
            has_many: {
              booking_instances: {
                class_name: "Studios::BookingInstance",
                has_lambda: false
              }
            }
          },
          "Curriculum::UserRankModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              rank: {
                has_lambda: false
              },
              guide_rank: {
                has_lambda: false
              }
            }
          },
          "Curriculum::ScoreModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              skill: {
                has_lambda: false
              }
            }
          },
          "Checklists::VersionModel": {
            belongs_to: {
              checklist: {
                has_lambda: false
              }
            },
            has_many: {
              items: {
                has_lambda: false
              },
              submissions: {
                has_lambda: false
              }
            }
          },
          "Checklists::ChecklistModel": {
            belongs_to: {
              current_version: {
                class_name: "Version",
                has_lambda: false
              }
            },
            has_many: {
              versions: {
                has_lambda: false
              },
              submissions: {
                through: "versions",
                has_lambda: false
              }
            }
          },
          "Checklists::SubmissionItemModel": {
            belongs_to: {
              submission: {
                has_lambda: false
              },
              item: {
                has_lambda: false
              }
            }
          },
          "Checklists::CommentModel": {
            belongs_to: {
              submission: {
                has_lambda: false
              },
              author: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Users::LearningStyleModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              author: {
                class_name: "Users::User",
                has_lambda: false
              },
              organization: {
                class_name: "Organizations::Organization",
                has_lambda: false
              }
            }
          },
          "Users::AddressModel": {
            belongs_to: {
              organization: {
                class_name: "::Organizations::Organization",
                has_lambda: false
              },
              user: {
                has_lambda: false
              }
            }
          },
          "Users::HowHeardAboutModel": {
            has_many: {
              users: {
                has_lambda: false
              }
            }
          },
          "Curriculum::BadgeDependentBadgeModel": {
            belongs_to: {
              badge: {
                has_lambda: false
              },
              dependent_badge: {
                class_name: "Badge",
                has_lambda: false
              }
            }
          },
          "Contracts::ContractModel": {
            belongs_to: {
              current_version: {
                class_name: "Version",
                has_lambda: false
              }
            },
            has_many: {
              versions: {
                has_lambda: false
              },
              executions: {
                through: "versions",
                has_lambda: false
              }
            }
          },
          "Contracts::VersionModel": {
            belongs_to: {
              contract: {
                has_lambda: false
              }
            },
            has_many: {
              executions: {
                has_lambda: false
              }
            }
          },
          "Contracts::ExecutionModel": {
            belongs_to: {
              version: {
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              organization: {
                class_name: "Organizations::Organization",
                has_lambda: false
              }
            }
          },
          "Curriculum::ActivitySkillModel": {
            belongs_to: {
              activity: {
                class_name: "Curriculum::Activities::Activity",
                has_lambda: false
              },
              skill: {
                has_lambda: false
              }
            }
          },
          "Curriculum::PointAdjustments::PointAdjustmentModel": {
            belongs_to: {
              adjusted_by: {
                class_name: "Users::User",
                has_lambda: false
              },
              skill: {
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Organizations::EmergencyContactModel": {
            belongs_to: {
              organization: {
                class_name: "Organizations::Organization",
                has_lambda: false
              }
            },
            has_many: {
              log_entries: {
                as: "referencing",
                class_name: "Logging::LogEntry",
                has_lambda: false
              }
            }
          },
          "Curriculum::GuideRankLearningPathLevelModel": {
            belongs_to: {
              guide_rank: {
                has_lambda: false
              },
              learning_path_level: {
                has_lambda: false
              }
            }
          },
          "Curriculum::LearningPathLevelSkillLevelModel": {
            belongs_to: {
              learning_path_level: {
                has_lambda: false
              },
              skill_level: {
                has_lambda: false
              }
            }
          },
          "Library::EngineModuleModel": {
            belongs_to: {
              engine: {
                has_lambda: false
              }
            },
            has_many: {
              engine_module_versions: {
                has_lambda: false
              },
              versions: {
                class_name: "Library::EngineModuleVersion",
                has_lambda: false
              }
            },
            has_one: {
              unpublished_version: {
                class_name: "Library::EngineModuleVersion",
                has_lambda: true
              }
            }
          },
          "Library::EngineEventModuleModel": {
            belongs_to: {
              engine_event_version: {
                has_lambda: false
              },
              engine_module: {
                has_lambda: false
              },
              source_engine_event_module: {
                class_name: "EngineEventModule",
                has_lambda: false
              }
            },
            has_one: {
              engine_event: {
                through: "engine_event_version",
                has_lambda: false
              }
            }
          },
          "Library::EngineMethodModuleModel": {
            belongs_to: {
              engine_method_version: {
                has_lambda: false
              },
              engine_module: {
                has_lambda: false
              },
              source_engine_method_module: {
                class_name: "EngineMethodModule",
                has_lambda: false
              }
            },
            has_one: {
              engine_method: {
                through: "engine_method_version",
                has_lambda: false
              }
            }
          },
          "Library::ObjectEventModuleModel": {
            belongs_to: {
              object_event_version: {
                has_lambda: false
              },
              engine_module: {
                has_lambda: false
              },
              source_object_event_module: {
                class_name: "ObjectEventModule",
                has_lambda: false
              }
            },
            has_one: {
              object_event: {
                through: "object_event_version",
                has_lambda: false
              }
            }
          },
          "Library::ObjectMethodModuleModel": {
            belongs_to: {
              object_method_version: {
                has_lambda: false
              },
              engine_module: {
                has_lambda: false
              },
              source_object_method_module: {
                class_name: "ObjectMethodModule",
                has_lambda: false
              }
            },
            has_one: {
              object_method: {
                through: "object_method_version",
                has_lambda: false
              }
            }
          },
          "Library::ObjectReactionModel": {
            belongs_to: {
              object_version: {
                has_lambda: false
              },
              source_object_reaction: {
                class_name: "ObjectReaction",
                has_lambda: false
              }
            },
            has_one: {
              object: {
                through: "object_version",
                has_lambda: false
              }
            },
            has_many: {
              object_reaction_modules: {
                has_lambda: false
              },
              engine_modules: {
                through: "object_reaction_modules",
                has_lambda: false
              },
              undeleted_engine_modules: {
                through: "object_reaction_modules",
                source: "engine_module",
                class_name: "EngineModule",
                has_lambda: true
              }
            }
          },
          "Library::ObjectReactionModuleModel": {
            belongs_to: {
              object_reaction: {
                has_lambda: false
              },
              engine_module: {
                has_lambda: false
              },
              source_object_reaction_module: {
                class_name: "ObjectReactionModule",
                has_lambda: false
              }
            },
            has_one: {
              object_version: {
                through: "object_reaction",
                has_lambda: false
              }
            }
          },
          "Curriculum::MissionStepActivityModel": {
            belongs_to: {
              mission_step: {
                class_name: "MissionSteps::MissionStep",
                has_lambda: false
              },
              activity: {
                class_name: "Activities::Activity",
                has_lambda: false
              }
            }
          },
          "Curriculum::RankLearningPathLevelModel": {
            belongs_to: {
              rank: {
                has_lambda: false
              },
              learning_path_level: {
                has_lambda: false
              }
            }
          },
          "Stream::UserActivities::UserActivityModel": {
            belongs_to: {
              subject: {
                polymorphic: true,
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              owner: {
                class_name: "Users::User",
                has_lambda: false
              }
            },
            has_many: {
              user_activity_emojis: {
                has_lambda: false
              }
            }
          },
          "Stream::UserActivityEmojiModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              user_activity: {
                class_name: "Stream::UserActivities::UserActivity",
                has_lambda: false
              }
            }
          },
          "Projects::VersionCommentEmojiModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              version_comment: {
                has_lambda: false
              }
            },
            has_one: {
              version: {
                through: "version_comment",
                has_lambda: false
              },
              project: {
                through: "version",
                has_lambda: false
              }
            }
          },
          "Projects::VersionCommentFlagModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              version_comment: {
                has_lambda: false
              },
              reviewer: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Projects::VersionFlagModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              project: {
                class_name: "Projects::Project",
                has_lambda: false
              },
              version: {
                class_name: "Projects::Version",
                has_lambda: false
              },
              reviewer: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Streaming::RegistrationModel": {
            belongs_to: {
              stream: {
                has_lambda: false
              },
              organization: {
                class_name: "Organizations::Organization",
                has_lambda: false
              },
              registrant: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Analytics::ProjectStatisticModel": {
            belongs_to: {
              project: {
                class_name: "Projects::Project",
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Analytics::StepStatisticModel": {
            belongs_to: {
              step: {
                class_name: "Curriculum::Steps::Step",
                has_lambda: false
              }
            }
          },
          "Analytics::UserStatisticModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Auth::SessionModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              organization: {
                class_name: "Organizations::Organization",
                has_lambda: false
              },
              access_token: {
                class_name: "Doorkeeper::AccessToken",
                has_lambda: false
              }
            }
          },
          "Billing::SubscriptionChargeModel": {
            belongs_to: {
              subscription: {
                class_name: "Billing::Subscription",
                has_lambda: false
              }
            }
          },
          "Communication::EmailEventModel": {
            belongs_to: {
              email: {
                foreign_key: "mandrill_email_id",
                primary_key: "mandrill_id",
                class_name: "Emails::Email",
                has_lambda: false
              }
            }
          },
          "Communication::MeetingStatusLogEntryModel": {
            belongs_to: {
              meeting: {
                has_lambda: false
              }
            }
          },
          "Communication::ParticipationsScheduleChangeModel": {
            belongs_to: {
              participation: {
                class_name: "Communication::Participations::Participation",
                has_lambda: false
              }
            },
            has_one: {
              meeting: {
                through: "participation",
                has_lambda: false
              }
            }
          },
          "Curriculum::AssetFileModel": {
            belongs_to: {
              author: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Curriculum::AssetVersionModel": {
            belongs_to: {
              asset: {
                class_name: "Curriculum::Assets::Asset",
                has_lambda: false
              },
              asset_file: {
                has_lambda: false
              }
            }
          },
          "Curriculum::BadgeSummaryModel": {
            belongs_to: {
              badge: {
                has_lambda: false
              }
            }
          },
          "Curriculum::CourseModel": {
            has_many: {
              difficulties: {
                has_lambda: false
              }
            },
            has_one: {
              easy: {
                class_name: "Difficulty",
                has_lambda: true
              },
              medium: {
                class_name: "Difficulty",
                has_lambda: true
              },
              hard: {
                class_name: "Difficulty",
                has_lambda: true
              }
            }
          },
          "Curriculum::CoursePrerequisiteModel": {
            belongs_to: {
              skill: {
                has_lambda: false
              },
              course: {
                has_lambda: false
              }
            }
          },
          "Curriculum::DifficultyModel": {
            belongs_to: {
              course: {
                has_lambda: false
              }
            },
            has_many: {
              tutorials: {
                has_lambda: false
              }
            }
          },
          "Curriculum::GuideRankSummaryModel": {
            belongs_to: {
              guide_rank: {
                has_lambda: false
              }
            }
          },
          "Curriculum::ImageModel": {
            belongs_to: {
              course: {
                has_lambda: false
              }
            }
          },
          "Curriculum::LearningPathLevelSummaryModel": {
            belongs_to: {
              learning_path_level: {
                has_lambda: false
              },
              learning_path: {
                has_lambda: false
              }
            }
          },
          "Curriculum::PointJournalModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              skill: {
                has_lambda: false
              },
              badge_achievement: {
                has_lambda: false
              },
              accomplishment: {
                has_lambda: false
              },
              mission_achievement: {
                has_lambda: false
              },
              point_adjustment: {
                class_name: "PointAdjustments::PointAdjustment",
                has_lambda: false
              }
            }
          },
          "Curriculum::ProgressModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              project: {
                class_name: "Projects::Project",
                has_lambda: false
              },
              tutorial: {
                has_lambda: false
              },
              step: {
                class_name: "Steps::Step",
                has_lambda: false
              }
            },
            has_one: {
              difficulty: {
                through: "tutorial",
                has_lambda: false
              },
              course: {
                through: "difficulty",
                has_lambda: false
              }
            }
          },
          "Curriculum::RankSummaryModel": {
            belongs_to: {
              rank: {
                has_lambda: false
              }
            }
          },
          "Curriculum::SkillLevelSummaryModel": {
            belongs_to: {
              rank: {
                has_lambda: false
              }
            }
          },
          "Curriculum::TutorialModel": {
            has_many: {
              steps: {
                class_name: "Steps::Step",
                has_lambda: true
              }
            },
            belongs_to: {
              difficulty: {
                has_lambda: false
              }
            },
            has_one: {
              course: {
                through: "difficulty",
                has_lambda: false
              }
            }
          },
          "Curriculum::TutorialPrerequisiteModel": {
            belongs_to: {
              skill: {
                has_lambda: false
              },
              tutorial: {
                has_lambda: false
              }
            },
            has_one: {
              difficulty: {
                through: "tutorial",
                has_lambda: false
              },
              course: {
                through: "difficulty",
                has_lambda: false
              }
            }
          },
          "Economy::BookingDepositModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              booking: {
                class_name: "Billing::Booking",
                has_lambda: false
              }
            }
          },
          "Economy::NrdyMembershipDepositModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              organization: {
                class_name: "Organizations::Organization",
                has_lambda: false
              }
            }
          },
          "Friends::FriendRequestModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              friend: {
                class_name: "Users::User",
                has_lambda: false
              },
              initiated_by: {
                class_name: "Users::User",
                has_lambda: false
              },
              accepted_by: {
                class_name: "Users::User",
                has_lambda: false
              },
              revoked_by: {
                class_name: "Users::User",
                has_lambda: false
              }
            },
            has_many: {
              friendships: {
                has_lambda: false
              }
            }
          },
          "Friends::FriendshipModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              friend: {
                class_name: "Users::User",
                has_lambda: false
              },
              friend_request: {
                has_lambda: false
              }
            }
          },
          "Guides::BackgroundCheckInvitationModel": {
            belongs_to: {
              checkr_account: {
                has_lambda: false
              }
            }
          },
          "Guides::BackgroundCheckReportModel": {
            belongs_to: {
              checkr_account: {
                has_lambda: false
              }
            }
          },
          "Hardware::VendorModel": {
            has_many: {
              models: {
                has_lambda: false
              }
            }
          },
          "I18n::TranslationModel": {
            belongs_to: {
              translation_source: {
                has_lambda: false
              }
            },
            has_many: {
              synthesized_clips: {
                class_name: "Narration::SynthesizedClip",
                has_lambda: false
              }
            }
          },
          "I18n::TranslationSourceModel": {
            has_many: {
              translations: {
                has_lambda: false
              }
            }
          },
          "Library::EngineConfigurationTemplateVersionModel": {
            belongs_to: {
              engine_configuration_template: {
                has_lambda: false
              },
              engine_version: {
                has_lambda: false
              },
              source_engine_configuration_template_version: {
                class_name: "EngineConfigurationTemplateVersion",
                has_lambda: false
              }
            },
            has_one: {
              engine: {
                through: "engine_version",
                has_lambda: false
              }
            },
            has_many: {
              engine_configuration_option_versions: {
                has_lambda: false
              },
              undeleted_engine_configuration_option_versions: {
                class_name: "EngineConfigurationOptionVersion",
                has_lambda: true
              }
            }
          },
          "Library::EngineEventTipModel": {
            belongs_to: {
              engine_event_version: {
                has_lambda: false
              },
              source_engine_event_tip: {
                class_name: "EngineEventTip",
                has_lambda: false
              }
            },
            has_one: {
              engine_event: {
                through: "engine_event_version",
                has_lambda: false
              }
            }
          },
          "Library::EngineEventVersionModel": {
            belongs_to: {
              engine_event: {
                has_lambda: false
              },
              engine_version: {
                has_lambda: false
              },
              source_engine_event_version: {
                class_name: "EngineEventVersion",
                has_lambda: false
              }
            },
            has_one: {
              engine: {
                through: "engine_version",
                has_lambda: false
              }
            },
            has_many: {
              engine_event_tips: {
                has_lambda: false
              },
              engine_event_modules: {
                has_lambda: false
              },
              engine_modules: {
                through: "engine_event_modules",
                has_lambda: false
              },
              undeleted_engine_modules: {
                through: "engine_event_modules",
                source: "engine_module",
                class_name: "EngineModule",
                has_lambda: true
              },
              engine_event_parameter_versions: {
                has_lambda: false
              },
              undeleted_engine_event_parameter_versions: {
                class_name: "EngineEventParameterVersion",
                has_lambda: true
              }
            }
          },
          "Library::EngineMethodTipModel": {
            belongs_to: {
              engine_method_version: {
                has_lambda: false
              },
              source_engine_method_tip: {
                class_name: "EngineMethodTip",
                has_lambda: false
              }
            },
            has_one: {
              engine_method: {
                through: "engine_method_version",
                has_lambda: false
              }
            }
          },
          "Library::EngineModuleVersionModel": {
            belongs_to: {
              engine_module: {
                has_lambda: false
              },
              engine_version: {
                has_lambda: false
              },
              source_engine_module_version: {
                class_name: "EngineModuleVersion",
                has_lambda: false
              }
            },
            has_one: {
              engine: {
                through: "engine_version",
                has_lambda: false
              }
            }
          },
          "Library::ObjectConstantValueVersionModel": {
            belongs_to: {
              object_constant_value: {
                has_lambda: false
              },
              object_constant_version: {
                has_lambda: false
              },
              source_object_constant_value_version: {
                class_name: "ObjectConstantValueVersion",
                has_lambda: false
              }
            },
            has_one: {
              object_version: {
                through: "object_constant_version",
                has_lambda: false
              }
            }
          },
          "Library::ObjectConstantVersionModel": {
            belongs_to: {
              object_constant: {
                has_lambda: false
              },
              object_version: {
                has_lambda: false
              },
              source_object_constant_version: {
                class_name: "ObjectConstantVersion",
                has_lambda: false
              }
            },
            has_one: {
              object: {
                through: "object_version",
                has_lambda: false
              }
            },
            has_many: {
              object_constant_value_versions: {
                has_lambda: false
              },
              undeleted_object_constant_value_versions: {
                class_name: "ObjectConstantValueVersion",
                has_lambda: true
              },
              undeleted_object_constant_value_versions_in_order: {
                class_name: "ObjectConstantValueVersion",
                has_lambda: true
              }
            }
          },
          "Library::ObjectEventTipModel": {
            belongs_to: {
              object_event_version: {
                has_lambda: false
              },
              source_object_event_tip: {
                class_name: "ObjectEventTip",
                has_lambda: false
              }
            },
            has_one: {
              object_event: {
                through: "object_event_version",
                has_lambda: false
              }
            }
          },
          "Library::ObjectEventVersionModel": {
            belongs_to: {
              object_event: {
                has_lambda: false
              },
              object_version: {
                has_lambda: false
              },
              source_object_event_version: {
                class_name: "ObjectEventVersion",
                has_lambda: false
              }
            },
            has_one: {
              object: {
                through: "object_version",
                has_lambda: false
              }
            },
            has_many: {
              object_event_modules: {
                has_lambda: false
              },
              engine_modules: {
                through: "object_event_modules",
                has_lambda: false
              },
              object_event_tips: {
                has_lambda: false
              },
              undeleted_engine_modules: {
                through: "object_event_modules",
                source: "engine_module",
                class_name: "EngineModule",
                has_lambda: true
              },
              object_event_parameter_versions: {
                has_lambda: false
              },
              undeleted_object_event_parameter_versions: {
                class_name: "ObjectEventParameterVersion",
                has_lambda: true
              }
            }
          },
          "Library::ObjectIncludedEngineEventVersionModel": {
            belongs_to: {
              object_included_engine_event: {
                has_lambda: false
              },
              object_version: {
                has_lambda: false
              },
              source_object_included_engine_event_version: {
                class_name: "ObjectIncludedEngineEvent",
                has_lambda: false
              }
            },
            has_one: {
              object: {
                through: "object_version",
                has_lambda: false
              },
              engine_event: {
                through: "object_included_engine_event",
                has_lambda: false
              }
            }
          },
          "Library::ObjectIncludedEngineMethodVersionModel": {
            belongs_to: {
              object_included_engine_method: {
                has_lambda: false
              },
              object_version: {
                has_lambda: false
              },
              source_object_included_engine_method_version: {
                class_name: "ObjectIncludedEngineMethod",
                has_lambda: false
              }
            },
            has_one: {
              object: {
                through: "object_version",
                has_lambda: false
              },
              engine_method: {
                through: "object_included_engine_method",
                has_lambda: false
              }
            }
          },
          "Library::ObjectMethodTipModel": {
            belongs_to: {
              object_method_version: {
                has_lambda: false
              },
              source_object_method_tip: {
                class_name: "ObjectMethodTip",
                has_lambda: false
              }
            },
            has_one: {
              object_method: {
                through: "object_method_version",
                has_lambda: false
              }
            }
          },
          "Lists::MemberModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              },
              organization: {
                class_name: "Organizations::Organization",
                has_lambda: false
              }
            }
          },
          "Logging::LogEntryModel": {
            belongs_to: {
              organization: {
                class_name: "Organizations::Organization",
                has_lambda: false
              },
              current_user: {
                class_name: "Users::User",
                has_lambda: false
              },
              actor: {
                class_name: "Users::User",
                has_lambda: false
              },
              oauth_application: {
                class_name: "Doorkeeper::Application",
                has_lambda: false
              },
              referencing: {
                polymorphic: true,
                has_lambda: false
              }
            }
          },
          "Marketing::NewsletterSubscriberModel": {
            belongs_to: {
              public_session: {
                class_name: "Marketing::PublicSession",
                has_lambda: false
              },
              referred_by: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Marketing::PublicSessionModel": {
            has_many: {
              children_counts: {
                has_lambda: false
              },
              events: {
                has_lambda: false
              },
              zip_codes: {
                has_lambda: false
              }
            }
          },
          "Narration::SynthesizedClipModel": {
            belongs_to: {
              voice: {
                class_name: "Narration::Voices::Voice",
                has_lambda: false
              },
              translation: {
                class_name: "I18n::Translation",
                has_lambda: false
              }
            }
          },
          "Opportunities::DelayedStageChangeModel": {
            belongs_to: {
              opportunity: {
                has_lambda: false
              },
              stage_changer: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Opportunities::MailchimpOpportunitySyncModel": {
            belongs_to: {
              opportunity: {
                has_lambda: false
              },
              mailchimp_tag: {
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Organizations::SchoolMetadataModel": {
            belongs_to: {
              organization: {
                has_lambda: false
              }
            }
          },
          "Products::MissionPackModel": {
            belongs_to: {
              mission: {
                has_lambda: false
              },
              pack: {
                has_lambda: false
              }
            }
          },
          "Products::PackModel": {
            belongs_to: {
              series: {
                has_lambda: false
              }
            }
          },
          "Products::SeriesModel": {
            belongs_to: {
              previous_series: {
                has_lambda: false
              }
            }
          },
          "Products::TradingCardModel": {
            belongs_to: {
              object: {
                has_lambda: false
              }
            }
          },
          "Products::TradingCardPackModel": {
            belongs_to: {
              trading_card: {
                has_lambda: false
              },
              pack: {
                has_lambda: false
              }
            }
          },
          "Projects::MinuteModel": {
            belongs_to: {
              project: {
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Projects::RevisionVersionModel": {
            belongs_to: {
              revision: {
                has_lambda: false
              },
              version: {
                has_lambda: false
              }
            }
          },
          "Projects::VersionPlayModel": {
            belongs_to: {
              public_session: {
                class_name: "Marketing::PublicSession",
                has_lambda: false
              },
              version: {
                has_lambda: false
              },
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            },
            has_one: {
              project: {
                through: "version",
                has_lambda: false
              }
            }
          },
          "Studios::CertificateModel": {
            belongs_to: {
              location: {
                has_lambda: false
              }
            }
          },
          "Studios::PhotoModel": {
            belongs_to: {
              photographer: {
                class_name: "Users::User",
                has_lambda: false
              },
              location: {
                has_lambda: false
              }
            },
            has_many: {
              photo_involvements: {
                has_lambda: false
              },
              attendances: {
                through: "photo_involvements",
                has_lambda: false
              },
              bookings: {
                through: "attendances",
                has_lambda: false
              }
            }
          },
          "Studios::PhotoInvolvementModel": {
            belongs_to: {
              photo: {
                has_lambda: false
              },
              attendance: {
                has_lambda: false
              }
            }
          },
          "Studios::ScheduleDateModel": {
            belongs_to: {
              occasion: {
                has_lambda: false
              }
            }
          },
          "Users::AccessTokenPasswordResetModel": {
            belongs_to: {
              password_reset: {
                class_name: "Users::PasswordReset",
                has_lambda: false
              },
              user: {
                has_lambda: false
              },
              access_token: {
                class_name: "Doorkeeper::AccessToken",
                has_lambda: false
              }
            }
          },
          "Users::Media::MediaRecordModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Users::PasswordResetModel": {
            belongs_to: {
              user: {
                has_lambda: false
              }
            }
          },
          "Websockets::BankBalanceMessageModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Websockets::ConnectionModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          },
          "Websockets::ScoreChangeMessageModel": {
            belongs_to: {
              user: {
                class_name: "Users::User",
                has_lambda: false
              }
            }
          }
        }
      end
    end
  end
end
