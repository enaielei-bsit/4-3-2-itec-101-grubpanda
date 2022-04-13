class UsersController < ApplicationController
    before_action() do |controller|
        # action = controller.action_name
        # if ["new", "create"].include?(action) && get_signed_in()
        #     redirect_to(root_url())
        # end
    end

    def new()
        @user = User.new(email: params.dig(:user, :email))
    end

    def create()
        @user = User.new(get_params())

        if @user.save()
            Utils.add_messages(
                flash,
                "Successful Account Registration",
                "You may now try signing in your account.",
                "negative",
            )
            redirect_to(new_user_url())
            # redirect_to(new_session_url(session: {
            #     email: @user.email
            # }))
        else
            Utils.add_messages(
                flash.now,
                "Failed Account Registration",
                @user.errors.full_messages,
                "negative",
            )
            render(:new, status: :unprocessable_entity)
        end
    end

    private()

    def get_params()
        return params.require(:user).permit(
            :email,
            :family_name,
            :given_name,
            :middle_name,
            :password,
            :password_confirmation
        )
    end
end
