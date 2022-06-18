class Order < ApplicationRecord
    belongs_to(:user)
    belongs_to(:address)
    has_many(:purchases, dependent: :destroy)

    def price()
        return (purchases.map() {|p| p.total}).sum()
    end

    def identifier()
        return "#{user.id}-#{created_at.to_i}"
    end
    
    def kiosks()
        return purchases.select("kiosks.name").joins("left join menus on purchases.menu_id = menus.id").joins("left join kiosks on menus.kiosk_id = kiosks.id").order("kiosks.name asc").map() {|r| r.name}
    end
end
