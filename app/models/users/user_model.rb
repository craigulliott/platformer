module Users
  class UserModel < BaseModel
    integer_field :age, array: true do
      allow_null
      default 5
      description ""
      case_insensitive
    end

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
