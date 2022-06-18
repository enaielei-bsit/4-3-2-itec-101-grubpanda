class User < ApplicationRecord
    has_secure_password()

    before_save() do
        self.email = self.email&.downcase()
    end

    has_many(:permissions, dependent: :destroy)
    has_many(:purchases, dependent: :destroy)
    has_many(:orders, dependent: :destroy)
    belongs_to(:address)

    validates(
        :email,
        uniqueness: true,
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
        :password,
        confirmation: true,
        length: {minimum: 6}
    )

    def full_name()
        name = [family_name, given_name].join(", ")
        name += middle_name ? " #{middle_name}" : ""
        return name
    end
end
