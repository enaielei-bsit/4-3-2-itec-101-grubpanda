module Utils
    module Controller
        def sign_in(user, remembered=false)
            session[:user_id] = user.id
            
            if remembered
                cookies.permanent.signed[:user_id] = user.id
                request = Utils.random()
                cookies.permanent[:request] = request
                user.update(session_digest: Utils.tokenize(request))
            end
        end
    
        def sign_out(user=nil)
            if user == nil || (user && signed_in(user))
                session[:user_id] = nil
                cookies.permanent.signed[:user_id] = nil
                cookies.permanent[:request] = nil
                user&.update(session_digest: nil)
            end
        end
    
        def signed_in(cls, user=nil)
            id = session[:user_id]
            request = nil
            if !id
                id = cookies.signed[:user_id]
                request = cookies[:request]
            end
    
            return nil if !id
            user = cls.find_by(id: id)
    
            if user && request
                if !Utils.compare(user.session_digest, request)
                    user = nil
                end
            end
    
            return user
        end
    
        def on_page(controller_name, *actions)
            return Utils.on_page(self, controller_name, *actions)
        end
    end

    def self.generate_message(title, subtitles=nil, type=nil)
        return {
            "title" => title,
            "subtitles" => !subtitles ? [] : (
                !subtitles.is_a?(Array) ? [subtitles] : subtitles
            ),
            "type" => type || "positive",
        }
    end

    def self.add_messages(container, *messages)
        first = messages.first
        if first
            container[:messages] = [] if !container[:messages]

            if first.is_a?(Array)
                container[:messages] << generate_message(
                    first[0],
                    first[1],
                    first[2],
                )
            else
                if first.is_a?(Hash)
                    for message in messages
                        container[:messages] << generate_message(
                            message["title"],
                            message["subtitles"],
                            message["type"],
                        )
                    end
                else
                    container[:messages] << generate_message(*messages)
                end
            end
        end
    end

    def self.get_title(title="", separator=" | ")
        if title.empty?()
            return BASE_TITLE
        else
            return "#{BASE_TITLE}#{separator}#{title}"
        end
    end

    def self.on_page(controller, controller_name, *action_names)
        name = controller.controller_name
        action = controller.action_name
        return name == controller_name && action_names.include?(action)
    end

    def self.random(size=10)
        return SecureRandom.urlsafe_base64(size)
    end

    def self.tokenize(value, cost=nil)
        return BCrypt::Password.create(value, cost: cost)
    end

    def self.compare(token, value)
        return BCrypt::Password.new(token) == value
    rescue
        return false
    end
end
