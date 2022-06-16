class Kiosk < ApplicationRecord
    before_save() do
        self.email = self.email&.downcase()
    end

    belongs_to(:address)
    has_many(:menus, dependent: :destroy)

    validates(
        :name,
        presence: true,
        uniqueness: true,
        length: {maximum: 100}
    )

    validates(
        :email,
        length: {maximum: 100},
        format: {
            with: URI::MailTo::EMAIL_REGEXP,
            message: "must be valid"
        }
    )

    validates(
        :mobile_number,
        format: {
            with: /[0-9]{11}/,
            message: "must be an 11-digit number"
        }
    )

    validates(
        :description,
        length: {maximum: 500}
    )
end
