class PurchasesController < ApplicationController
    before_action() do |controller|
        action = controller.action_name
        if ["new", "create", "destroy"].include?(action) && !@signed_in
            redirect_to(new_session_url())
        end
    end

    def edit()
    end

    def update()
    end

    def destroy()
    end
end
