class ProductsController < ApplicationController
    before_action() do |controller|
        action = controller.action_name
        if ["new", "create", "destroy"].include?(action) && !@signed_in
            redirect_to(new_session_url())
        end
        
        @products = Product.page(params[:page] || 1).per(params[:count] || 10)
    end
    
    def show()
        @product = params[:id]
        @name = "Product #{@product}"
    end

    def new()
        @product = Product.new()
    end

    def create()
        @product = Product.new(get_params())

        if @product.save()
            Utils.add_messages(
                flash,
                "Successful Product Registration",
                "The product has been registered.",
                "positive",
            )
            redirect_to(new_product_url())
            return
        end

        Utils.add_messages(
            flash.now,
            "Failed Product Registration",
            @product.errors.full_messages,
            "negative",
        )
        render(:new, status: :unprocessable_entity)
    end

    def destroy()
    end

    private()

    def get_params()
        return params.require(:product).permit(
            :name,
            :serving_size,
            :description,
            :images
        )
    end
end
