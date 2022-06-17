class ApisController < ApplicationController
    skip_before_action :verify_authenticity_token

    before_action() do |controller|
        action = controller.action_name
        if ["index", "new", "create", "destroy"].include?(action) && !@signed_in
            redirect_to(new_session_url())
        end
    end

    def index()
        operation = get_params()[:operation]
        args = get_params()[:args].as_json

        if operation == "get"
            if args == "products"
                render(json: Product.all)
                return
            elsif args == "kiosks"
                render(json: Kiosk.all)
                return
            end
        elsif operation == "post"
            if args.is_a?(Hash)
                type = args.dig("type")
                search = args.dig("search")
                values = args.dig("values")

                if type == "update-purchase"
                    p = Purchase.find_by(search)
                    if p && (p.user_id == @signed_in.id || @admin) && !p.order
                        p.update(values)
                        if p.save()
                            render(json: {
                                status: 200,
                            })
                            return
                        end
                    end
                    render(json: {
                        status: 404,
                    })
                    return
                else
                end
            else
            end
        end

        render(plain: "")
    end

    private()

    def get_params()
        # params.require([:operation])
        # params.permit(:operation, :args)
        return params
    end
end
