class Order < ApplicationRecord
    belongs_to(:user)
    belongs_to(:address)
    has_many(:purchases, dependent: :destroy)

    def price()
        return (purchases.map() {|p| p.total}).sum()
    end
end
