class ApplicationController < ActionController::Base
    include ActionView::Helpers::DateHelper
    include Utils::Controller

    $VALID_IMAGE_UPLOAD = "image/*"

    $TITLE = "GrubPanda"
    $AUTHOR = "Nommel Isanar L. Amolat"

    before_action() do |controller|
        @permissions = [
            Permission::CLIENT
        ]
        @signed_in ||= signed_in(User)

        action = controller.action_name
        if ["index"].include?(action) && !@signed_in
            redirect_to(new_session_url())
        end
    end

    def index()
    end
end
