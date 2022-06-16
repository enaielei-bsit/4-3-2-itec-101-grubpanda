class UsersController < ApplicationController
    before_action() do |controller|
        action = controller.action_name
        if ["new", "create"].include?(action) && @signed_in
            redirect_to(root_url())
        end
    end

    def new()
        @user = User.new(email: params.dig(:user, :email))
    end

    def create()
        pp = get_params()
        @user = User.new(
            email: pp[:email],
            family_name: pp[:family_name],
            given_name: pp[:given_name],
            middle_name: pp[:middle_name],
            password: pp[:password],
            password_confirmation: pp[:password_confirmation],
        )

        @address = Address.new(
            region: pp[:region],
            province: pp[:province],
            city: pp[:city],
            barangay: pp[:barangay],
            street: pp[:street],
        )

        if @address.valid?()
            @address.save()
            @user.update(address_id: @address.id)

            if @user.save()
                Utils.add_messages(
                    flash,
                    "Successful Account Registration",
                    "You may now try signing in your account.",
                    "positive",
                )
                redirect_to(new_session_url(session: {
                    email: @user.email
                }))
                return
            else
                @user.address.destroy()
            end
        end
        @user.validate()
        @user.errors.delete(:address)
        
        Utils.add_messages(
            flash.now,
            "Failed Account Registration",
            @user.errors.full_messages + @address.errors.full_messages,
            "negative",
        )
        render(:new, status: :unprocessable_entity)
    end

    private()

    def get_params()
        return params.require(:user).permit(
            :email,
            :family_name,
            :given_name,
            :middle_name,
            :region,
            :province,
            :city,
            :barangay,
            :street,
            :password,
            :password_confirmation
        )
    end
end
