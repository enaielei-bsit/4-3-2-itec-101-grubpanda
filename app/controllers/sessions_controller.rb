class SessionsController < ApplicationController
    $ATTEMPT = 5
    $ATTEMPT_REFRESH = 1.minutes * $ATTEMPT
    $ATTEMPT_WAIT = 1.minutes

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
        per = cookies.permanent

        if @user
            if @user.authenticate(@session[:password])
                per.signed[:attempt_wait] = nil
                per.signed[:attempt_start] = nil
                per.signed[:attempt] = 0
                sign_in(@user, @session[:remembered] == "1")
                return redirect_to(root_url())
            else
                wait = per.signed[:attempt_wait]
                attempt = per.signed[:attempt]

                if wait
                    from = Time.now
                    to = wait.to_time + $ATTEMPT_WAIT
                    if Time.now < to
                        delta = distance_of_time_in_words(from, to, include_seconds: true)
                        Utils.add_messages(
                            flash.now,
                            "Failed Account Authentication",
                            "You have reached your maximum number of attempts. You are blocked from signing in for #{delta}.",
                            "negative",
                        )
                    else
                        per.signed[:attempt_wait] = nil
                        per.signed[:attempt_start] = nil
                        per.signed[:attempt] = 0
                    end
                end

                if !per.signed[:attempt_wait]
                    if per.signed[:attempt].to_i == 0
                        per.signed[:attempt_start] = Time.now.to_s
                    end

                    if per.signed[:attempt_start]
                        if Time.now >= (per.signed[:attempt_start].to_time + $ATTEMPT_REFRESH)
                            per.signed[:attempt] = 0
                            per.signed[:attempt_start] = Time.now.to_s
                        end
                    end

                    per.signed[:attempt] = (per.signed[:attempt].to_i + 1).clamp(0, $ATTEMPT)
                    if per.signed[:attempt].to_i >= $ATTEMPT
                        per.signed[:attempt_wait] = Time.now.to_s
                    end

                    Utils.add_messages(
                        flash.now,
                        "Failed Account Authentication",
                        "Password is incorrect. You have #{$ATTEMPT - per.signed[:attempt].to_i} attempt(s) remaining.",
                        "negative",
                    )
                end
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
