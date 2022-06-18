class Purchase < ApplicationRecord
    belongs_to(:user, foreign_key: true)
    belongs_to(:menu, foreign_key: true)
    belongs_to(:order, optional: true)

    validates(
        :user,
        presence: true,
        uniqueness: {
            scope: [:menu, :order_id],
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
    
    def kiosks()
        return Purchase.select("kiosks.name").joins("left join menus on purchases.menu_id = menus.id").joins("left join kiosks on menus.kiosk_id = kiosks.id").order("kiosks.name asc").map() {|r| r.name}
    end
end
