$ rake generate:from_db\[primary,codeverse_development,true,audit,i18n\] --trace
$ rake db:dynamic_migrate --trace

Display is a reserved word, its a standard lib ruby method. Change the enum from MissionStepInsertableModel and MissionStepModel from `display` to `display_type`

I18n is reserved, so skipping our I18n schema

remove belongs_to "I18n::TranslationModel" from SynthesizedClipModel

remove numeric_field :latitude and numeric_field :longitude from
  EmailEventModel
  ZipCodeModel
  PublicSessionModel
  AddressModel
  LocationModel
  AddressModel

AvailabilityInstanceModel belongs to availability and also has an availability column (these names collide)
rename `integer_field :attendees` to `integer_field :attending`
rename `integer_field :availability` to `integer_field :available`

rename all `as: :unknown` for associations


has_many :charges, model: "Billing::InvoiceChargeModel"  should be  has_many :charges, model: "Billing::Charges::InvoiceChargeModel"


some sti class n ames were too long

"Communication::Emails::AcquisitionStreamFollowUp::TrialInformation",
"Communication::Emails::AcquisitionStreamRegistered::RegistrationCreated",
"Communication::Emails::AcquisitionStreamRegistered::JoinStreamLink",
"Communication::Emails::AcquisitionStreamRegistered::TwentyFourHourReminder",
"Communication::Emails::AcquisitionStreamRegistered::TwoHourReminder",
"Communication::Emails::ConversionStreamFollowUp::TrialInformation",
"Communication::Emails::ConversionStreamRegistered::RegistrationCreated",
"Communication::Emails::ConversionStreamRegistered::JoinStreamLink",
"Communication::Emails::ConversionStreamRegistered::TwentyFourHourReminder",
"Communication::Emails::ConversionStreamRegistered::TwoHourReminder",
"Communication::Emails::GuideContractorAgreementSigned::RenewalNotice",
"Communication::Emails::GuideContractorAgreementSigned::RenewalNoticeWithoutRaise",
"Communication::Emails::GuideContractorAgreementSigned::TerminationNotice",
"Communication::Emails::OnDemandStreamRegistered::RegistrationCreated",
"Communication::Emails::PartnerGroupClassBooked::TwentyFourHourReminder",
"Communication::Emails::PartnerGroupClassBooked::TwoHourReminder",
"Communication::Emails::PartnerGroupClassFollowUp::MembershipInformation",
"Communication::Emails::UsscVirtualCampBooked::RegistrationPacket",
"Communication::Emails::UsscVirtualCampFollowUp::TrialInformation",
"Communication::Emails::VirtualTrialBooked::TwentyFourHourReminder",
"Communication::Emails::VirtualTrialPeriod::Day5WithSubscription",
"Communication::Emails::VirtualTrialPeriod::Day7WithSubscription",
"Communication::Emails::VirtualTrialPeriod::TrialCreatedWithSubscription"
"Billing::SubscriptionDiscounts::SupernovaStarterSignUpIncentive",
"Billing::SubscriptionDiscounts::SupernovaStarterRetentionIncentive",
"Billing::SubscriptionDiscounts::SupernovaStarterLoyaltyIncentive",
"Billing::SubscriptionDiscounts::SupernovaLiteRetentionIncentive",
"Communication::TextMessages::InfluencerClassTwentyFourHourReminder",
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
"Communication::TextMessages::InfluencerProgramLead::AccountSetup",
"Communication::TextMessages::MissedMemberSession::LeftVoicemail",
"Communication::TextMessages::MissedMemberSession::PhoneCallNoAnswer",
"Communication::TextMessages::MissedTrialSession::ExpressedInterest",
"Communication::TextMessages::MissedTrialSession::PhoneCallNoAnswer",
"Communication::TextMessages::OnDemandStreamFollowUp::ExpressedInterest",
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
"Communication::TextMessages::UsscVirtualCampBooked::TwoDayReminder",
"Communication::TextMessages::UsscVirtualCampFollowUp::ExpressedInterest",
"Communication::TextMessages::UsscVirtualCampFollowUp::LeftVoicemail",
"Communication::TextMessages::UsscVirtualCampFollowUp::PhoneCallNoAnswer",
"Communication::TextMessages::VirtualClassesLead::ExpressedInterest",
"Communication::TextMessages::VirtualClassesLead::LeftVoicemail1",
"Communication::TextMessages::VirtualClassesLead::LeftVoicemail2",
"Communication::TextMessages::VirtualClassesLead::PhoneCallNoAnswer1",
"Communication::TextMessages::VirtualClassesLead::PhoneCallNoAnswer2",
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
"Communication::TextMessages::VirtualTrialFollowUp::ExpressedInterest1",
"Communication::TextMessages::VirtualTrialFollowUp::ExpressedInterest2",
"Communication::TextMessages::VirtualTrialFollowUp::LeftVoicemail1",
"Communication::TextMessages::VirtualTrialFollowUp::LeftVoicemail2",
"Communication::TextMessages::VirtualTrialFollowUp::PhoneCallNoAnswer1",
"Communication::TextMessages::VirtualTrialFollowUp::PhoneCallNoAnswer2",
"Opportunities::Assignments::VirtualClassesLead::InboundCommunication",
"Opportunities::Assignments::VirtualClassesProspect::InboundCommunication",
"Opportunities::Assignments::InfluencerProgramLead::InboundCommunication",
"Opportunities::Assignments::ConversionStreamFollowUp::PhoneCall",
"Opportunities::Assignments::ConversionStreamFollowUp::InboundCommunication",
"Opportunities::Assignments::AcquisitionStreamFollowUp::PhoneCall",
"Opportunities::Assignments::AcquisitionStreamFollowUp::InboundCommunication",
"Opportunities::Assignments::OnDemandStreamFollowUp::InboundCommunication",
"Opportunities::Assignments::CollectLearningStyles::InboundCommunication",
"Opportunities::Assignments::VirtualTrialPeriod::InboundCommunication",
"Opportunities::Assignments::GuideContractorAgreementSigned::RenewalReview",
"Opportunities::Assignments::GuideContractorAgreementSigned::TerminationFollowUp",
"Opportunities::Assignments::PartnerGroupClassFollowUp::PhoneCall",