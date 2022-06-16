class Product < ApplicationRecord
    has_many(:menu_items, dependent: :destroy)

    validates(
        :name,
        presence: true,
        uniqueness: true,
        length: {maximum: 100}
    )

    validates(
        :serving_size,
        presence: true,
        length: {maximum: 100}
    )

    validates(
        :description,
        length: {maximum: 500}
    )
end
