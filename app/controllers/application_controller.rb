class ApplicationController < ActionController::Base
    include Utils::Controller

    $TITLE = "GrubPanda"
    $AUTHOR = "Nommel Isanar L. Amolat"

    before_action() do |controller|
        @signed_in ||= signed_in(User)

        action = controller.action_name
        if ["index"].include?(action) && !@signed_in
            redirect_to(new_session_url())
        end
    end

    def index()
    end
end
