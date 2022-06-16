class Address < ApplicationRecord    
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
end