class UUID < Grape::Validations::Validators::Base
  def self.validate uuid
    REGULAR_EXPRESSIONS[:UUID].match uuid
  end

  def validate_param!(attr_name, params)
    unless REGULAR_EXPRESSIONS[:UUID].match params[attr_name]
      fail Grape::Exceptions::Validation, params: [@scope.full_name(attr_name)], message: "must be a valid UUID"
    end
  end
end
