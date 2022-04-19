module ApplicationHelper
    def page_link(properties={})
        props = properties
        options = props[:options] || {}
        html_options = props[:html_options] || {}

        body = props[:body] || ""
        return link_to(body || page.to_s(), options, html_options)
    end

    def placeholder(text="?")
        text = text.split(" ").join("+")
        return "https://via.placeholder.com/100/a34c13/fff?text=#{text}"
    end
end
