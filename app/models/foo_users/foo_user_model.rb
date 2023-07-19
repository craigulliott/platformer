module FooUsers
  class FooUserModel < PlatformModel
    string_field :name do
      description ""
      case_insensitive
    end

    email_field :email do
      description ""
      case_insensitive
      unique
    end
  end
end
