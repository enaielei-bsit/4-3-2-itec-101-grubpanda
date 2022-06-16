class MenuItem < ApplicationRecord
    belongs_to(:menu)
    belongs_to(:product)

    validates(
        :quantity,
        presence: true,
        comparison: {
            greater_than_or_equal_to: 0
        }
    )
end
