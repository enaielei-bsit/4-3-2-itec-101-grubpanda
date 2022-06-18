class OrdersController < ApplicationController
    before_action() do |controller|
        action = controller.action_name
        if ["index", "new", "create", "destroy"].include?(action) && !@signed_in
            redirect_to(new_session_url())
        end
        
        @order = Order.new()
        @orders = Order.where(user_id: @signed_in.id).page(params[:page] || 1).per(params[:count] || 10)
    end

    def show()
        @order = Order.find_by(id: params[:id])
        @purchases = @order.purchases.page(params[:page] || 1).per(params[:count] || 10)
        @id = @order.identifier
    end

    def index()
    end
end
