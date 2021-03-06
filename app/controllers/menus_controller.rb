class MenusController < ApplicationController
    before_action() do |controller|
        action = controller.action_name
        if ["new", "create", "destroy"].include?(action) && !@signed_in
            redirect_to(new_session_url())
        end

        @products = Product.all
        @menus = Menu.page(params[:page] || 1).per(params[:count] || 10)
    end
    
    def show()
        @menu = params[:id]
        @name = "Menu #{@menu}"
    end

    def new()
        @menu = Menu.new()
    end

    def create()
        pp = get_params()

        @menu = Menu.new(
            kiosk_id: pp[:kiosk_id],
            name: pp[:name],
            price: pp[:price],
            description: pp[:description],
        )

        errs = []
        items = []

        if @menu.save()
            begin
                items = pp[:items].split(",").map() {|i| i.split("-")}.map() {|i| MenuItem.new(
                    menu_id: @menu.id,
                    product_id: i.first,
                    quantity: i.last
                )}

                if items.length == 0
                    raise RangeError.new
                end

                for item in items
                    if !item.save()
                        raise
                    end
                end

                Utils.add_messages(
                    flash,
                    "Successful Menu Registration",
                    "The menu has been registered.",
                    "positive",
                )
                redirect_to(new_menu_url())
                return
            rescue RangeError
                errs << "Menu must at least have one Item"
            rescue => e
                errs << "Menu Items are invalid"
            end
        end
        for item in items
            item.destroy()
        end
        @menu.destroy()

        Utils.add_messages(
            flash.now,
            "Failed Menu Registration",
            @menu.errors.full_messages + errs,
            "negative",
        )
        render(:new, status: :unprocessable_entity)
    end

    def destroy()
    end

    private()

    def get_params()
        return params.require(:menu).permit(
            :kiosk_id,
            :name,
            :price,
            :items,
            :description
        )
    end
end
