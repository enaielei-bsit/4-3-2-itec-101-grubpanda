class KiosksController < ApplicationController
    before_action() do |controller|
        action = controller.action_name
        if ["new", "create", "destroy"].include?(action) && !@signed_in
            redirect_to(new_session_url())
        end
    end

    def show()
        @kiosk = params[:id]
        @name = "Store #{@kiosk}"
    end

    def new()
        @kiosk = {}
    end

    def create()
        # @user = User.new(get_params())

        # if @user.save()
        #     Utils.add_messages(
        #         flash,
        #         "Successful Account Registration",
        #         "You may now try signing in your account.",
        #         "positive",
        #     )
        #     redirect_to(new_session_url(session: {
        #         email: @user.email
        #     }))
        # else
        #     Utils.add_messages(
        #         flash.now,
        #         "Failed Account Registration",
        #         @user.errors.full_messages,
        #         "negative",
        #     )
        #     render(:new, status: :unprocessable_entity)
        # end
    end

    def destroy()
    end

    private()

    def get_params()
        return params.require(:kiosk).permit(
            :name,
            :email,
            :mobile_number,
            :region,
            :province,
            :city,
            :barangay,
            :street,
            :description,
            :images
        )
    end
end
