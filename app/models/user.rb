class User < ApplicationRecord
    has_secure_password()

    before_save() do
        self.email = self.email&.downcase()
    end

    validates(
        :email,
        length: {maximum: 100},
        format: {
            with: URI::MailTo::EMAIL_REGEXP,
            message: "must be valid"
        }
    )

    validates(
        :family_name,
        presence: true,
        length: {maximum: 25}
    )

    validates(
        :given_name,
        presence: true,
        length: {maximum: 50}
    )

    validates(
        :middle_name,
        length: {maximum: 25}
    )
    
    validates(
        :region,
        presence: true,
        length: {maximum: 50}
    )
    
    validates(
        :province,
        presence: true,
        length: {maximum: 50}
    )
    
    validates(
        :city,
        presence: true,
        length: {maximum: 50}
    )
    
    validates(
        :barangay,
        presence: true,
        length: {maximum: 50}
    )
    
    validates(
        :street,
        presence: true,
        length: {maximum: 100}
    )

    validates(
        :password,
        confirmation: true,
        length: {minimum: 6}
    )
end
