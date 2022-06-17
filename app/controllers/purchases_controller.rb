class PurchasesController < ApplicationController
    before_action() do |controller|
        action = controller.action_name
        if ["edit", "new", "create", "update", "destroy"].include?(action) && !@signed_in
            redirect_to(new_session_url())
        end
        
        @purchase = Purchase.new()
        purchases = Purchase.where(user_id: @signed_in.id).order(created_at: :asc)
        @purchases = purchases.where("order_id is null")
        @ptotal = (@purchases.map() {|p| p.total}).sum()
        @opurchases = purchases.where("order_id is not null").page(params[:page] || 1).per(params[:count] || 10)
    end

    def create()
        pp = get_params()
        ref = params[:ref]
        errs = []
        items = []

        begin
            items = pp[:orders].split(",").map() {|i| i.split("-")}.map() do |i|
                p = Purchase.find_by(user_id: @signed_in.id, menu_id: i.first)
                if !p
                    p = Purchase.new(
                        user_id: @signed_in.id,
                        menu_id: i.first,
                        quantity: i.last
                    )
                else
                    p.update(quantity: p.quantity + i.last.to_i)
                end
                p
            end
        rescue
            items = []
            errs << "Cart Purchases are invalid"
        end

        if items.length == 0
            errs << "Must at least have one Purchase"
        else
            for item in items
                if !item.save()
                    errs << "Cart Purchases are invalid"
                    break
                end
            end
        end

        if errs.length == 0
            Utils.add_messages(
                flash,
                "Successful Cart Addition",
                "The purchase has been added to cart.",
                "positive",
            )
            if !ref
                redirect_to(edit_cart_url())
            else
                redirect_to(ref)
            end
            return
        else
            if !ref
                Utils.add_messages(
                    flash.now,
                    "Failed Cart Addition",
                    errs,
                    "negative",
                )
                render(:edit, status: :unprocessable_entity)
            else
                Utils.add_messages(
                    flash,
                    "Failed Cart Addition",
                    errs,
                    "negative",
                )
                redirect_to(ref)
            end
        end
    end

    def edit()
    end

    def update()
        orders = get_params()[:orders].split(",").map() do |o|
            Purchase.find_by(id: o)
        end
        orders = orders.compact

        address = Address.new()
        order = Order.new()

        errs = []

        if orders.length == 0
            errs << "Purchases must be checked first before checking out"
        else
            address.update(
                region: @signed_in.address.region,
                province: @signed_in.address.province,
                city: @signed_in.address.city,
                barangay: @signed_in.address.barangay,
                street: @signed_in.address.street,
            )
            address.save()

            order.update(
                user_id: @signed_in.id,
                address_id: address.id
            )
            if order.save()
                for o in orders
                    o.update(order_id: order.id, price: o.total)
                    if !o.save()
                        errs << "Purchases cannot be processed"
                    end
                end
            else
                errs << "Order cannot be created"
            end

            if errs.length == 0
                Utils.add_messages(
                    flash,
                    "Successful Order",
                    "Your purchases has been ordered.",
                    "positive",
                )
                redirect_to(edit_cart_url())
            else
                order.address.destroy()
                order.destroy()

                for o in orders
                    o.update(order_id: nil, price: 0)
                    o.save()
                end

                Utils.add_messages(
                    flash.now,
                    "Failed Order",
                    errs,
                    "negative",
                )
                render(:edit, status: :unprocessable_entity)
            end
        end
    end

    def destroy()
    end

    private()

    def get_params()
        return params.require(:purchase).permit(
            :orders
        )
    end
end
