class Menu < ApplicationRecord
    belongs_to(:kiosk)
    has_many(:menu_items, dependent: :destroy)

    validates(
        :name,
        presence: true,
        length: {maximum: 100},
        uniqueness: {
            scope: :kiosk_id,
            message: "for the kiosk's menu has already been taken"
        }
    )

    validates(
        :price,
        comparison: {
            greater_than_or_equal_to: 0
        }
    )

    validates(
        :description,
        length: {maximum: 500}
    )
end
