module Platformer
  module Generators
    module FromDatabase
      module Models
        STI_MODELS = {
          "Curriculum::Assets::Asset": {
            medium: [
              "Curriculum::Assets::Photo",
              "Curriculum::Assets::Audio",
              "Curriculum::Assets::Video"
            ]
          },
          "Communication::Emails::Email": {
            template: [
              "Communication::Emails::BirthdayPartyReceipt",
              "Communication::Emails::BookingCreated",
              "Communication::Emails::CampReceipt",
              "Communication::Emails::CertificationSupportConversation",
              "Communication::Emails::CrewMembershipInfo",
              "Communication::Emails::DayCampReceipt",
              "Communication::Emails::ExplorerAccountBillingNotification",
              "Communication::Emails::ExplorerConfirmation",
              "Communication::Emails::ExplorerLaunch",
              "Communication::Emails::ExplorerWelcome",
              "Communication::Emails::FieldTripReceipt",
              "Communication::Emails::GuideSupportConversation",
              "Communication::Emails::Inbound",
              "Communication::Emails::InfluencerConversation",
              "Communication::Emails::KidsNightOutReceipt",
              "Communication::Emails::LeadConversation",
              "Communication::Emails::PasswordCreate",
              "Communication::Emails::PasswordReset",
              "Communication::Emails::ProductPurchaseReceipt",
              "Communication::Emails::SubscriptionCreated",
              "Communication::Emails::SupportConversation",
              "Communication::Emails::ThreeDayMemberBillingNotification",
              "Communication::Emails::VirtualClassOneHourReminder",
              "Communication::Emails::VirtualClassTwentyFourHourReminder",
              "Communication::Emails::WelcomeKit",
              "Communication::Emails::AcquisitionStreamFollowUp::Attended",
              "Communication::Emails::AcquisitionStreamFollowUp::TrialInformation",
              "Communication::Emails::AcquisitionStreamFollowUp::FollowUp1",
              "Communication::Emails::AcquisitionStreamFollowUp::FollowUp2",
              "Communication::Emails::AcquisitionStreamRegistered::RegistrationCreated",
              "Communication::Emails::AcquisitionStreamRegistered::JoinStreamLink",
              "Communication::Emails::AcquisitionStreamRegistered::TwentyFourHourReminder",
              "Communication::Emails::AcquisitionStreamRegistered::TwoHourReminder",
              "Communication::Emails::AdultPlayerHighIntent::AccountCreated",
              "Communication::Emails::AdultPlayerLowIntent::AccountCreated",
              "Communication::Emails::CanceledMember::Confirmation",
              "Communication::Emails::CanceledMember::CheckIn",
              "Communication::Emails::ConversionStreamFollowUp::Attended",
              "Communication::Emails::ConversionStreamFollowUp::TrialInformation",
              "Communication::Emails::ConversionStreamFollowUp::FollowUp1",
              "Communication::Emails::ConversionStreamFollowUp::FollowUp2",
              "Communication::Emails::ConversionStreamRegistered::RegistrationCreated",
              "Communication::Emails::ConversionStreamRegistered::JoinStreamLink",
              "Communication::Emails::ConversionStreamRegistered::TwentyFourHourReminder",
              "Communication::Emails::ConversionStreamRegistered::TwoHourReminder",
              "Communication::Emails::GiftOfCode::Welcome",
              "Communication::Emails::MissedTrialSession::WeMissedYou",
              "Communication::Emails::PastDueSubscription::BookingsCanceled",
              "Communication::Emails::PastDueSubscription::UpdatePaymentInfo",
              "Communication::Emails::GuideCertification::Welcome",
              "Communication::Emails::GuideCertification::FollowUp",
              "Communication::Emails::GuideContractorAgreementSigned::RenewalNotice",
              "Communication::Emails::GuideContractorAgreementSigned::RenewalNoticeWithoutRaise",
              "Communication::Emails::GuideContractorAgreementSigned::TerminationNotice",
              "Communication::Emails::GuideOnboarding::Welcome",
              "Communication::Emails::GuideOnboarding::FollowUp",
              "Communication::Emails::InfluencerProgramLead::AccountSetup",
              "Communication::Emails::InfluencerProgramLead::FollowUp1",
              "Communication::Emails::InfluencerProgramLead::FollowUp2",
              "Communication::Emails::InfluencerProgramLead::FollowUp3",
              "Communication::Emails::InfluencerProgramLead::FollowUp4",
              "Communication::Emails::KidPlayer::AccountCreated",
              "Communication::Emails::OnDemandStreamFollowUp::Attended",
              "Communication::Emails::OnDemandStreamFollowUp::FollowUp1",
              "Communication::Emails::OnDemandStreamFollowUp::FollowUp2",
              "Communication::Emails::OnDemandStreamRegistered::RegistrationCreated",
              "Communication::Emails::PartnerGroupClassBooked::BookingCreated",
              "Communication::Emails::PartnerGroupClassBooked::TwentyFourHourReminder",
              "Communication::Emails::PartnerGroupClassBooked::TwoHourReminder",
              "Communication::Emails::PartnerGroupClassFollowUp::ClassRecap",
              "Communication::Emails::PartnerGroupClassFollowUp::MembershipInformation",
              "Communication::Emails::UnusedCredits::EndOfCycleReminder",
              "Communication::Emails::UnusedCredits::NewCredits",
              "Communication::Emails::UnusedCredits::OneWeekReminder",
              "Communication::Emails::UsscVirtualCampBooked::RegistrationPacket",
              "Communication::Emails::UsscVirtualCampBooked::TwoDayReminder",
              "Communication::Emails::UsscVirtualCampBooked::CampRecap",
              "Communication::Emails::UsscVirtualCampFollowUp::TrialInformation",
              "Communication::Emails::VirtualClassesLead::AccountCreated",
              "Communication::Emails::VirtualClassesLead::ShareGames",
              "Communication::Emails::VirtualClassesLead::ShareVideos",
              "Communication::Emails::VirtualClassesLead::ShareEvents",
              "Communication::Emails::VirtualClassesLead::CheckingIn1",
              "Communication::Emails::VirtualClassesLead::CheckingIn2",
              "Communication::Emails::VirtualClassesProspect::AccountCreated",
              "Communication::Emails::VirtualClassesProspect::ShareGames",
              "Communication::Emails::VirtualClassesProspect::ShareVideos",
              "Communication::Emails::VirtualClassesProspect::ShareEvents",
              "Communication::Emails::VirtualClassesProspect::CheckingIn1",
              "Communication::Emails::VirtualClassesProspect::CheckingIn2",
              "Communication::Emails::VirtualTrialBooked::OneHourReminder",
              "Communication::Emails::VirtualTrialBooked::TrialCreated",
              "Communication::Emails::VirtualTrialBooked::TwentyFourHourReminder",
              "Communication::Emails::VirtualTrialFollowUp::Attended",
              "Communication::Emails::VirtualTrialPeriod::Day5",
              "Communication::Emails::VirtualTrialPeriod::Day5WithSubscription",
              "Communication::Emails::VirtualTrialPeriod::Day7",
              "Communication::Emails::VirtualTrialPeriod::Day7WithSubscription",
              "Communication::Emails::VirtualTrialPeriod::TrialCreated",
              "Communication::Emails::VirtualTrialPeriod::TrialCreatedWithSubscription"
            ]
          },
          "Hardware::Components::Component": {
            driver: [
              "Hardware::Components::CodeverseModule",
              "Hardware::Components::Display",
              "Hardware::Components::DoorController",
              "Hardware::Components::EstimoteBeacon",
              "Hardware::Components::Imac",
              "Hardware::Components::StudentIpad",
              "Hardware::Components::InstructorIpad",
              "Hardware::Components::RetailIpad",
              "Hardware::Components::FixedIpad",
              "Hardware::Components::HomePod",
              "Hardware::Components::LifxBulb",
              "Hardware::Components::MakerBot",
              "Hardware::Components::Carvey",
              "Hardware::Components::MerakiAccessPoint",
              "Hardware::Components::MerakiRouter",
              "Hardware::Components::MovingSpotLight",
              "Hardware::Components::MovingMiniSpotLight",
              "Hardware::Components::MovingWashLight",
              "Hardware::Components::NovaServer",
              "Hardware::Components::NetworkInterface",
              "Hardware::Components::Portal",
              "Hardware::Components::Phone",
              "Hardware::Components::Printer",
              "Hardware::Components::Thermostat",
              "Hardware::Components::Projector",
              "Hardware::Components::Speaker",
              "Hardware::Components::SmartGlass",
              "Hardware::Components::PowerSwitch",
              "Hardware::Components::PowerOutlet",
              "Hardware::Components::StrobeLight",
              "Hardware::Components::RobotArm",
              "Hardware::Components::UbiquitiCamera",
              "Hardware::Components::UbiquitiSwitch"
            ]
          },
          "Incidents::Incident": {
            topic: [
              "Incidents::Behavior",
              "Incidents::CustomerService",
              "Incidents::Facilities",
              "Incidents::HealthAndSafety",
              "Incidents::Other",
              "Incidents::Technology"
            ]
          },
          "Billing::InvoiceBookings::InvoiceBooking": {
            allocation: [
              "Billing::InvoiceBookings::Deposit",
              "Billing::InvoiceBookings::Balance"
            ]
          },
          "Opportunities::Opportunity": {
            journey: [
              "Opportunities::VirtualClassesLead",
              "Opportunities::VirtualClassesProspect",
              "Opportunities::GiftOfCode",
              "Opportunities::KidPlayer",
              "Opportunities::AdultPlayerHighIntent",
              "Opportunities::AdultPlayerLowIntent",
              "Opportunities::InfluencerProgramLead",
              "Opportunities::CollectLearningStyles",
              "Opportunities::MissedTrialSession",
              "Opportunities::VirtualTrialBooked",
              "Opportunities::VirtualTrialFollowUp",
              "Opportunities::VirtualTrialPeriod",
              "Opportunities::CanceledMember",
              "Opportunities::MissedMemberSession",
              "Opportunities::PastDueSubscription",
              "Opportunities::UnhappySurvey",
              "Opportunities::UnusedCredits",
              "Opportunities::GuideCertification",
              "Opportunities::GuideContractorAgreementSigned",
              "Opportunities::GuideOnboarding",
              "Opportunities::UsscVirtualCampBooked",
              "Opportunities::UsscVirtualCampFollowUp",
              "Opportunities::PartnerGroupClassBooked",
              "Opportunities::PartnerGroupClassFollowUp",
              "Opportunities::ConversionStreamRegistered",
              "Opportunities::ConversionStreamFollowUp",
              "Opportunities::AcquisitionStreamRegistered",
              "Opportunities::AcquisitionStreamFollowUp",
              "Opportunities::OnDemandStreamRegistered",
              "Opportunities::OnDemandStreamFollowUp"
            ]
          },
          "Organizations::Membership": {
            role: [
              "Organizations::Ownership",
              "Organizations::Instructorship",
              "Organizations::Studentship",
              "Organizations::Pickupship",
              "Organizations::Attendship"
            ]
          },
          "Organizations::Organization": {
            classification: [
              "Organizations::School",
              "Organizations::Internal",
              "Organizations::Household",
              "Organizations::Club",
              "Organizations::Guide",
              "Organizations::Influencer"
            ]
          },
          "Users::User": {
            scope: [
              "Users::Account",
              "Users::Administrator",
              "Users::Child",
              "Users::Guide"
            ]
          },
          "Billing::Credits::Credit": {
            source: [
              "Billing::Credits::Subscription",
              "Billing::Credits::Promotion",
              "Billing::Credits::Loyalty",
              "Billing::Credits::Adjustment",
              "Billing::Credits::Overage"
            ]
          },
          "Communication::PhoneCalls::PhoneCall": {
            leg: [
              "Communication::PhoneCalls::Inbound",
              "Communication::PhoneCalls::Outbound",
              "Communication::PhoneCalls::QueueInvitation",
              "Communication::PhoneCalls::ClickToDial",
              "Communication::PhoneCalls::StudioInvitation"
            ]
          },
          "Curriculum::Steps::Step": {
            boilerplate: [
              "Curriculum::Steps::Code",
              "Curriculum::Steps::Info",
              "Curriculum::Steps::Write",
              "Curriculum::Steps::Slide"
            ]
          },
          "Billing::SubscriptionDiscounts::SubscriptionDiscount": {
            reason: [
              "Billing::SubscriptionDiscounts::SaasSignUpIncentive",
              "Billing::SubscriptionDiscounts::SaasRetentionIncentive",
              "Billing::SubscriptionDiscounts::SaasReferralCredit",
              "Billing::SubscriptionDiscounts::SaasCommitmentIncentive",
              "Billing::SubscriptionDiscounts::ExplorerSignUpIncentive",
              "Billing::SubscriptionDiscounts::ExplorerRetentionIncentive",
              "Billing::SubscriptionDiscounts::ExplorerReferralCredit",
              "Billing::SubscriptionDiscounts::ExplorerCommitmentIncentive",
              "Billing::SubscriptionDiscounts::StudioSignUpIncentive",
              "Billing::SubscriptionDiscounts::StudioRetentionIncentive",
              "Billing::SubscriptionDiscounts::StudioReferralCredit",
              "Billing::SubscriptionDiscounts::StudioCommitmentIncentive",
              "Billing::SubscriptionDiscounts::StudioManagerCredit",
              "Billing::SubscriptionDiscounts::StudioManagerIncentive",
              "Billing::SubscriptionDiscounts::StudioPausedIncentive",
              "Billing::SubscriptionDiscounts::NovaSignUpIncentive",
              "Billing::SubscriptionDiscounts::NovaRetentionIncentive",
              "Billing::SubscriptionDiscounts::NovaReferralCredit",
              "Billing::SubscriptionDiscounts::NovaLoyaltyIncentive",
              "Billing::SubscriptionDiscounts::SupernovaStarterSignUpIncentive",
              "Billing::SubscriptionDiscounts::SupernovaStarterRetentionIncentive",
              "Billing::SubscriptionDiscounts::SupernovaStarterReferralCredit",
              "Billing::SubscriptionDiscounts::SupernovaStarterLoyaltyIncentive",
              "Billing::SubscriptionDiscounts::SupernovaLiteSignUpIncentive",
              "Billing::SubscriptionDiscounts::SupernovaLiteRetentionIncentive",
              "Billing::SubscriptionDiscounts::SupernovaLiteReferralCredit",
              "Billing::SubscriptionDiscounts::SupernovaLiteLoyaltyIncentive",
              "Billing::SubscriptionDiscounts::SupernovaSignUpIncentive",
              "Billing::SubscriptionDiscounts::SupernovaRetentionIncentive",
              "Billing::SubscriptionDiscounts::SupernovaReferralCredit",
              "Billing::SubscriptionDiscounts::SupernovaLoyaltyIncentive",
              "Billing::SubscriptionDiscounts::SupernovaProSignUpIncentive",
              "Billing::SubscriptionDiscounts::SupernovaProRetentionIncentive",
              "Billing::SubscriptionDiscounts::SupernovaProReferralCredit",
              "Billing::SubscriptionDiscounts::SupernovaProLoyaltyIncentive"
            ]
          },
          "Communication::TextMessages::TextMessage": {
            template: [
              "Communication::TextMessages::AbandonedGuide",
              "Communication::TextMessages::AttachedGuide",
              "Communication::TextMessages::GuideScheduleSummary",
              "Communication::TextMessages::Inbound",
              "Communication::TextMessages::Outbound",
              "Communication::TextMessages::ParentSurvey",
              "Communication::TextMessages::ParentUpdate",
              "Communication::TextMessages::Share",
              "Communication::TextMessages::VirtualExpeditionReminder1",
              "Communication::TextMessages::VirtualExpeditionReminder2",
              "Communication::TextMessages::InfluencerClassOneHourReminder",
              "Communication::TextMessages::InfluencerClassTwentyFourHourReminder",
              "Communication::TextMessages::PartnerGroupClassOneHourReminder",
              "Communication::TextMessages::PartnerGroupClassTwentyFourHourReminder",
              "Communication::TextMessages::AcquisitionStreamFollowUp::Attended",
              "Communication::TextMessages::AcquisitionStreamFollowUp::ExpressedInterest",
              "Communication::TextMessages::AcquisitionStreamFollowUp::FollowUp1",
              "Communication::TextMessages::AcquisitionStreamFollowUp::FollowUp2",
              "Communication::TextMessages::AcquisitionStreamFollowUp::LeftVoicemail",
              "Communication::TextMessages::AcquisitionStreamFollowUp::PhoneCallNoAnswer",
              "Communication::TextMessages::AcquisitionStreamFollowUp::TrialInformation",
              "Communication::TextMessages::AcquisitionStreamRegistered::OneHourReminder",
              "Communication::TextMessages::AcquisitionStreamRegistered::RegistrationCreated",
              "Communication::TextMessages::AcquisitionStreamRegistered::TwentyFourHourReminder",
              "Communication::TextMessages::AcquisitionStreamRegistered::TenMinuteReminder",
              "Communication::TextMessages::CanceledMember::CheckIn",
              "Communication::TextMessages::CanceledMember::LeftVoicemail",
              "Communication::TextMessages::CanceledMember::PhoneCallNoAnswer",
              "Communication::TextMessages::CollectLearningStyles::Fallback",
              "Communication::TextMessages::CollectLearningStyles::FallbackReminder",
              "Communication::TextMessages::CollectLearningStyles::LeftVoicemail",
              "Communication::TextMessages::CollectLearningStyles::PhoneCallNoAnswer",
              "Communication::TextMessages::ConversionStreamFollowUp::Attended",
              "Communication::TextMessages::ConversionStreamFollowUp::ExpressedInterest",
              "Communication::TextMessages::ConversionStreamFollowUp::FollowUp1",
              "Communication::TextMessages::ConversionStreamFollowUp::FollowUp2",
              "Communication::TextMessages::ConversionStreamFollowUp::LeftVoicemail",
              "Communication::TextMessages::ConversionStreamFollowUp::PhoneCallNoAnswer",
              "Communication::TextMessages::ConversionStreamFollowUp::TrialInformation",
              "Communication::TextMessages::ConversionStreamRegistered::OneHourReminder",
              "Communication::TextMessages::ConversionStreamRegistered::RegistrationCreated",
              "Communication::TextMessages::ConversionStreamRegistered::TwentyFourHourReminder",
              "Communication::TextMessages::ConversionStreamRegistered::TenMinuteReminder",
              "Communication::TextMessages::GiftOfCode::Welcome",
              "Communication::TextMessages::InfluencerProgramLead::AccountSetup",
              "Communication::TextMessages::InfluencerProgramLead::FollowUp1",
              "Communication::TextMessages::InfluencerProgramLead::FollowUp2",
              "Communication::TextMessages::InfluencerProgramLead::FollowUp3",
              "Communication::TextMessages::InfluencerProgramLead::FollowUp4",
              "Communication::TextMessages::MissedMemberSession::LeftVoicemail",
              "Communication::TextMessages::MissedMemberSession::PhoneCallNoAnswer",
              "Communication::TextMessages::MissedMemberSession::WeMissedYou",
              "Communication::TextMessages::MissedTrialSession::ExpressedInterest",
              "Communication::TextMessages::MissedTrialSession::LeftVoicemail",
              "Communication::TextMessages::MissedTrialSession::PhoneCallNoAnswer",
              "Communication::TextMessages::MissedTrialSession::WeMissedYou",
              "Communication::TextMessages::OnDemandStreamFollowUp::Attended",
              "Communication::TextMessages::OnDemandStreamFollowUp::ExpressedInterest",
              "Communication::TextMessages::OnDemandStreamFollowUp::FollowUp1",
              "Communication::TextMessages::OnDemandStreamFollowUp::FollowUp2",
              "Communication::TextMessages::OnDemandStreamFollowUp::LeftVoicemail",
              "Communication::TextMessages::OnDemandStreamFollowUp::PhoneCallNoAnswer",
              "Communication::TextMessages::OnDemandStreamRegistered::RegistrationCreated",
              "Communication::TextMessages::PastDueSubscription::BookingsCanceled",
              "Communication::TextMessages::PastDueSubscription::LeftVoicemail",
              "Communication::TextMessages::PastDueSubscription::PhoneCallNoAnswer",
              "Communication::TextMessages::PastDueSubscription::UpdatePaymentInfo",
              "Communication::TextMessages::PartnerGroupClassFollowUp::ExpressedInterest",
              "Communication::TextMessages::PartnerGroupClassFollowUp::LeftVoicemail",
              "Communication::TextMessages::PartnerGroupClassFollowUp::MembershipInformation",
              "Communication::TextMessages::PartnerGroupClassFollowUp::PhoneCallNoAnswer",
              "Communication::TextMessages::UnhappySurvey::LeftVoicemail",
              "Communication::TextMessages::UnhappySurvey::PhoneCallNoAnswer",
              "Communication::TextMessages::UnusedCredits::EndOfCycleReminder",
              "Communication::TextMessages::UnusedCredits::NewCredits",
              "Communication::TextMessages::UnusedCredits::OneWeekReminder",
              "Communication::TextMessages::UsscVirtualCampBooked::TwoDayReminder",
              "Communication::TextMessages::UsscVirtualCampFollowUp::ExpressedInterest",
              "Communication::TextMessages::UsscVirtualCampFollowUp::LeftVoicemail",
              "Communication::TextMessages::UsscVirtualCampFollowUp::PhoneCallNoAnswer",
              "Communication::TextMessages::VirtualClassesLead::ExpressedInterest",
              "Communication::TextMessages::VirtualClassesLead::LeftVoicemail1",
              "Communication::TextMessages::VirtualClassesLead::LeftVoicemail2",
              "Communication::TextMessages::VirtualClassesLead::PhoneCallNoAnswer1",
              "Communication::TextMessages::VirtualClassesLead::PhoneCallNoAnswer2",
              "Communication::TextMessages::VirtualClassesLead::SuggestTimes",
              "Communication::TextMessages::VirtualClassesLead::ShareGames",
              "Communication::TextMessages::VirtualClassesLead::ShareVideos",
              "Communication::TextMessages::VirtualClassesLead::ShareEvents",
              "Communication::TextMessages::VirtualClassesLead::CheckingIn1",
              "Communication::TextMessages::VirtualClassesLead::CheckingIn2",
              "Communication::TextMessages::VirtualClassesProspect::ExpressedInterest",
              "Communication::TextMessages::VirtualClassesProspect::LeftVoicemail1",
              "Communication::TextMessages::VirtualClassesProspect::LeftVoicemail2",
              "Communication::TextMessages::VirtualClassesProspect::PhoneCallNoAnswer1",
              "Communication::TextMessages::VirtualClassesProspect::PhoneCallNoAnswer2",
              "Communication::TextMessages::VirtualClassesProspect::SuggestTimes",
              "Communication::TextMessages::VirtualClassesProspect::ShareGames",
              "Communication::TextMessages::VirtualClassesProspect::ShareVideos",
              "Communication::TextMessages::VirtualClassesProspect::ShareEvents",
              "Communication::TextMessages::VirtualClassesProspect::CheckingIn1",
              "Communication::TextMessages::VirtualClassesProspect::CheckingIn2",
              "Communication::TextMessages::VirtualTrialBooked::EveningBeforeReminder",
              "Communication::TextMessages::VirtualTrialBooked::OneHourReminder",
              "Communication::TextMessages::VirtualTrialFollowUp::Attended",
              "Communication::TextMessages::VirtualTrialFollowUp::ExpressedInterest1",
              "Communication::TextMessages::VirtualTrialFollowUp::ExpressedInterest2",
              "Communication::TextMessages::VirtualTrialFollowUp::LeftVoicemail1",
              "Communication::TextMessages::VirtualTrialFollowUp::LeftVoicemail2",
              "Communication::TextMessages::VirtualTrialFollowUp::PhoneCallNoAnswer1",
              "Communication::TextMessages::VirtualTrialFollowUp::PhoneCallNoAnswer2",
              "Communication::TextMessages::VirtualTrialPeriod::Day5",
              "Communication::TextMessages::VirtualTrialPeriod::Day7",
              "Communication::TextMessages::VirtualTrialPeriod::TrialCreated"
            ]
          },
          "Billing::CouponSubscriptionDiscounts::CouponSubscriptionDiscount": {
            target: [
              "Billing::CouponSubscriptionDiscounts::Explorer",
              "Billing::CouponSubscriptionDiscounts::Studio",
              "Billing::CouponSubscriptionDiscounts::Saas",
              "Billing::CouponSubscriptionDiscounts::Nova",
              "Billing::CouponSubscriptionDiscounts::SupernovaLite",
              "Billing::CouponSubscriptionDiscounts::SupernovaPro",
              "Billing::CouponSubscriptionDiscounts::SupernovaStarter",
              "Billing::CouponSubscriptionDiscounts::Supernova"
            ]
          },
          "Curriculum::Activities::Activity": {
            processor: [
              "Curriculum::Activities::Manual",
              "Curriculum::Activities::MessageBus",
              "Curriculum::Activities::Event",
              "Curriculum::Activities::Kidscript",
              "Curriculum::Activities::ProjectEvent",
              "Curriculum::Activities::ProjectKidscript",
              "Curriculum::Activities::MissionEvent",
              "Curriculum::Activities::MissionKidscript"
            ]
          },
          "Curriculum::MissionObjects::MissionObject": {
            basis: [
              "Curriculum::MissionObjects::Dependency",
              "Curriculum::MissionObjects::Featured"
            ]
          },
          "Curriculum::Missions::Mission": {
            series: [
              "Curriculum::Missions::Standard",
              "Curriculum::Missions::Bonus",
              "Curriculum::Missions::Competition"
            ]
          },
          "Billing::SubscriptionAddOns::SubscriptionAddOn": {
            product: [
              "Billing::SubscriptionAddOns::Saas",
              "Billing::SubscriptionAddOns::Studio",
              "Billing::SubscriptionAddOns::Explorer",
              "Billing::SubscriptionAddOns::Nova",
              "Billing::SubscriptionAddOns::SupernovaStarter",
              "Billing::SubscriptionAddOns::SupernovaLite",
              "Billing::SubscriptionAddOns::Supernova",
              "Billing::SubscriptionAddOns::SupernovaPro"
            ]
          },
          "Curriculum::MissionSteps::MissionStep": {
            boilerplate: [
              "Curriculum::MissionSteps::Code",
              "Curriculum::MissionSteps::Info",
              "Curriculum::MissionSteps::Write",
              "Curriculum::MissionSteps::Checkpoint",
              "Curriculum::MissionSteps::ObjectImporter",
              "Curriculum::MissionSteps::Example",
              "Curriculum::MissionSteps::Insert",
              "Curriculum::MissionSteps::Submit",
              "Curriculum::MissionSteps::Video",
              "Curriculum::MissionSteps::Quiz",
              "Curriculum::MissionSteps::Audio",
              "Curriculum::MissionSteps::Image"
            ]
          },
          "Communication::Participations::Participation": {
            scope: [
              "Communication::Participations::Guide",
              "Communication::Participations::Child"
            ]
          },
          "Opportunities::Assignments::Assignment": {
            topic: [
              "Opportunities::Assignments::VirtualClassesLead::PhoneCall",
              "Opportunities::Assignments::VirtualClassesLead::InboundCommunication",
              "Opportunities::Assignments::VirtualClassesProspect::PhoneCall",
              "Opportunities::Assignments::VirtualClassesProspect::InboundCommunication",
              "Opportunities::Assignments::InfluencerProgramLead::PhoneCall",
              "Opportunities::Assignments::InfluencerProgramLead::InboundCommunication",
              "Opportunities::Assignments::ConversionStreamFollowUp::PhoneCall",
              "Opportunities::Assignments::ConversionStreamFollowUp::InboundCommunication",
              "Opportunities::Assignments::AcquisitionStreamFollowUp::PhoneCall",
              "Opportunities::Assignments::AcquisitionStreamFollowUp::InboundCommunication",
              "Opportunities::Assignments::OnDemandStreamFollowUp::PhoneCall",
              "Opportunities::Assignments::OnDemandStreamFollowUp::InboundCommunication",
              "Opportunities::Assignments::CollectLearningStyles::PhoneCall",
              "Opportunities::Assignments::CollectLearningStyles::InboundCommunication",
              "Opportunities::Assignments::MissedTrialSession::PhoneCall",
              "Opportunities::Assignments::VirtualTrialPeriod::InboundCommunication",
              "Opportunities::Assignments::VirtualTrialFollowUp::PhoneCall",
              "Opportunities::Assignments::CanceledMember::AccountReview",
              "Opportunities::Assignments::CanceledMember::PhoneCall",
              "Opportunities::Assignments::MissedMemberSession::PhoneCall",
              "Opportunities::Assignments::PastDueSubscription::PhoneCall",
              "Opportunities::Assignments::UnhappySurvey::Review",
              "Opportunities::Assignments::UnhappySurvey::EscalatedReview",
              "Opportunities::Assignments::UnhappySurvey::PhoneCall",
              "Opportunities::Assignments::UnusedCredits::PhoneCall",
              "Opportunities::Assignments::GuideCertification::TrainingReview",
              "Opportunities::Assignments::GuideContractorAgreementSigned::RenewalReview",
              "Opportunities::Assignments::GuideContractorAgreementSigned::TerminationFollowUp",
              "Opportunities::Assignments::GuideOnboarding::TrainingReview",
              "Opportunities::Assignments::GuideOnboarding::CheckoutReview",
              "Opportunities::Assignments::PartnerGroupClassFollowUp::PhoneCall",
              "Opportunities::Assignments::UsscVirtualCampFollowUp::PhoneCall"
            ]
          },
          "Narration::Voices::Voice": {
            synthesizer: [
              "Narration::Voices::ResembleSynthesizedVoice"
            ]
          },
          "Billing::Charge": {
            source: [
              "Billing::SubscriptionCharge",
              "Billing::InvoiceCharge"
            ]
          },
          "Guides::Earnings::Earning": {
            pricing_model: [
              "Guides::Earnings::Trial",
              "Guides::Earnings::Expedition"
            ]
          },
          "Curriculum::PointAdjustments::PointAdjustment": {
            reason: [
              "Curriculum::PointAdjustments::RateLimit",
              "Curriculum::PointAdjustments::ManualAdjustment"
            ]
          },
          "Stream::UserActivities::UserActivity": {
            verb: [
              "Stream::UserActivities::CreatedProject",
              "Stream::UserActivities::EarnedBadge",
              "Stream::UserActivities::CompletedMission",
              "Stream::UserActivities::StartedMission",
              "Stream::UserActivities::PublishedProjectVersion",
              "Stream::UserActivities::PublishedProject",
              "Stream::UserActivities::PlayedGame",
              "Stream::UserActivities::GameWasPlayed",
              "Stream::UserActivities::RankedUp",
              "Stream::UserActivities::StarredProject",
              "Stream::UserActivities::ProjectWasStarred",
              "Stream::UserActivities::FollowedUser",
              "Stream::UserActivities::NewFollower",
              "Stream::UserActivities::AddedToLeaderboard",
              "Stream::UserActivities::PlacedOnLeaderboard",
              "Stream::UserActivities::PlacedOnYourLeaderboard",
              "Stream::UserActivities::BeatenOnLeaderboard",
              "Stream::UserActivities::BumpedFromLeaderboardPodium",
              "Stream::UserActivities::AddedCommentToProjectVersion",
              "Stream::UserActivities::ReceivedCommentOnProjectVersion",
              "Stream::UserActivities::AddedEmojiToProjectVersion",
              "Stream::UserActivities::ReceivedEmojiOnProjectVersion",
              "Stream::UserActivities::AddedEmojiToProjectVersionComment",
              "Stream::UserActivities::ReceivedEmojiOnProjectVersionComment",
              "Stream::UserActivities::AddedEmojiToUserActivity",
              "Stream::UserActivities::ReceivedEmojiOnUserActivity",
              "Stream::UserActivities::ReferredOrganization",
              "Stream::UserActivities::GainedCoinsFromNrdyMembership",
              "Stream::UserActivities::AppStoreSubmissionReviewed",
              "Stream::UserActivities::AppStoreSubmissionLaunched"
            ]
          },
          "Lists::Member": {
            list: [
              "Lists::AbandonedCampCart",
              "Lists::AbandonedMembershipCart",
              "Lists::AbandoneExplorerCart",
              "Lists::BookedCamp",
              "Lists::BookedTrialClass"
            ]
          },
          "Users::Media::MediaRecord": {
            medium: [
              "Users::Media::Photo",
              "Users::Media::Audio",
              "Users::Media::Video",
              "Users::Media::Screenshot",
              "Users::Media::ScreenCapture",
              "Users::Media::AnalyticsPhoto",
              "Users::Media::AnalyticsAudio",
              "Users::Media::AnalyticsVideo",
              "Users::Media::AnalyticsScreenshot",
              "Users::Media::AnalyticsScreenCapture"
            ]
          }
        }
      end
    end
  end
end
