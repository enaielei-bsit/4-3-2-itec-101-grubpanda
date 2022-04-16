class SessionsController < ApplicationController
    before_action() do |controller|
        action = controller.action_name
        if ["new", "create"].include?(action) && @signed_in
            redirect_to(root_url())
        end
    end

    def new()
        @session = get_params()
    end
    
    def create()
        @session = get_params()
        @user = User.find_by(email: @session[:email])

        if @user
            if @user.authenticate(@session[:password])
                # Utils.add_messages(
                #     flash,
                #     "Successful Account Registration",
                #     "You may now try signing in your account.",
                #     "negative",
                # )
                sign_in(@user, @session[:remembered] == "1")
                return redirect_to(root_url())
            else
                Utils.add_messages(
                    flash.now,
                    "Failed Account Authentication",
                    "Password is incorrect",
                    "negative",
                )
            end
        else
            Utils.add_messages(
                flash.now,
                "Failed Account Authentication",
                "Email does not exist",
                "negative",
            )
        end
        render(:new, status: :unprocessable_entity)
    end

    def destroy()
        sign_out()
        @signed_in = nil
        redirect_to(new_session_url())
    end

    private()

    def get_params()
        return params.require(:session).permit(
            :email,
            :password,
            :remembered,
        )
    rescue
        return {
            email: nil,
            password: nil,
            remembered: false
        }
    end
end
