class ApplicationController < ActionController::Base
    include ActionView::Helpers::DateHelper
    include Utils::Controller

    $VALID_IMAGE_UPLOAD = "image/*"

    $TITLE = "GrubPanda"
    $AUTHOR = "Nommel Isanar L. Amolat"

    before_action() do |controller|
        @permissions = [
            Permission::ADMIN,
            Permission::CLIENT,
            Permission::CUSTOMER
        ]
        @signed_in ||= signed_in(User)

        
        per = Permission
        pers = @permissions
        @admin = pers.include?(per::ADMIN)
        @client = pers.include?(per::CLIENT)
        @customer = pers.include?(per::CUSTOMER)

        action = controller.action_name
        if ["index"].include?(action) && !@signed_in
            redirect_to(new_session_url())
        end
    end

    def index()
    end
end
