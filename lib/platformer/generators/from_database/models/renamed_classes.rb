module Platformer
  module Generators
    module FromDatabase
      module Models
        RENAMED_CLASSES = {
          "Billing::InvoiceCharge": "Billing::Charges::InvoiceCharge",
          "Billing::SubscriptionCharge": "Billing::Charges::SubscriptionCharge",

          "Organizations::Ownership": "Organizations::Memberships::Ownership",
          "Organizations::Instructorship": "Organizations::Memberships::Instructorship",
          "Organizations::Studentship": "Organizations::Memberships::Studentship",
          "Organizations::Pickupship": "Organizations::Memberships::Pickupship",
          "Organizations::Attendship": "Organizations::Memberships::Attendship",
          "Organizations::School": "Organizations::Organizations::School",
          "Organizations::Internal": "Organizations::Organizations::Internal",
          "Organizations::Household": "Organizations::Organizations::Household",
          "Organizations::Club": "Organizations::Organizations::Club",
          "Organizations::Guide": "Organizations::Organizations::Guide",
          "Organizations::Influencer": "Organizations::Organizations::Influencer",

          "Users::Account": "Users::Users::Account",
          "Users::Administrator": "Users::Users::Administrator",
          "Users::Child": "Users::Users::Child",
          "Users::Guide": "Users::Users::Guide",

        }
      end
    end
  end
end
