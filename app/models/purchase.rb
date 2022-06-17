class Purchase < ApplicationRecord
    belongs_to(:user)
    belongs_to(:menu)
    belongs_to(:order, optional: true)

    validates(
        :user,
        presence: true,
        uniqueness: {
            scope: :menu,
            message: "with this Menu as purchase already exists"
        }
    )

    validates(
        :price,
        comparison: {
            greater_than_or_equal_to: 0
        }
    )

    validates(
        :quantity,
        presence: true,
        comparison: {
            greater_than_or_equal_to: 0
        }
    )

    def total()
        return menu.price * quantity
    end

    def final_total()
        return price * quantity
    end
end
