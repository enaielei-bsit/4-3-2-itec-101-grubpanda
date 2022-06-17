class KiosksController < ApplicationController
    before_action() do |controller|
        action = controller.action_name
        if ["new", "create", "destroy"].include?(action) && !@signed_in
            redirect_to(new_session_url())
        end
        
        @kiosks = Kiosk.page(params[:page] || 1).per(params[:count] || 10)
    end

    def show()
        @kiosk = Kiosk.find_by(id: params[:id])
        @menus = @kiosk.menus.page(params[:page] || 1).per(params[:count] || 10)
        @name = @kiosk.name
    end

    def new()
        @kiosk = Kiosk.new()
    end

    def create()
        pp = get_params()
        @kiosk = Kiosk.new(
            name: pp[:name],
            email: pp[:email],
            mobile_number: pp[:mobile_number],
            description: pp[:description],
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
            @kiosk.update(address_id: @address.id)

            if @kiosk.save()
                Utils.add_messages(
                    flash,
                    "Successful Kiosk Registration",
                    "The kiosk has been registered.",
                    "positive",
                )
                redirect_to(new_kiosk_url())
                return
            else
                @kiosk.address.destroy()
            end
        end
        @kiosk.validate()
        @kiosk.errors.delete(:address)

        Utils.add_messages(
            flash.now,
            "Failed Kiosk Registration",
            @kiosk.errors.full_messages + @address.errors.full_messages,
            "negative",
        )
        render(:new, status: :unprocessable_entity)
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
