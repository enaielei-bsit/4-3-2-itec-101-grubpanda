class ApisController < ApplicationController
    before_action() do |controller|
        action = controller.action_name
        if ["index", "new", "create", "destroy"].include?(action) && !@signed_in
            redirect_to(new_session_url())
        end
    end

    def index()
        operation = get_params()[:operation]
        args = get_params()[:args]

        if operation == "get"
            if args == "products"
                render(json: Product.all)
                return
            elsif args == "kiosks"
                render(json: Kiosk.all)
                return
            end
        end

        render(plain: "")
    end

    private()

    def get_params()
        params.require([:operation])
        params.permit(:operation, :args)
        return params
    end
end
