class WingsController < ApplicationController
  layout "mindcom"

  def index
    @wings = MgWing.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])
    
    # Check if it's an API request (via format or params)
    respond_to do |format|
      format.html # renders the default index.html.erb
      format.json do
        if params[:api_request].present?
          render json: @wings, status: :created
        else
          render json: { error: "API request parameter missing" }, status: :bad_request
        end
      end
    end
  end

  # POST /wings
  def create
        @wings = MgWing.new(wing_params)
        @wings.mg_school_id = session[:current_user_school_id]
        @wings.is_deleted= 0
        @wings.created_by= session[:user_id]
        @wings.updated_by= session[:user_id]
        if @wings.save
          render json: { message: "Academic year Created"}, status: :created
        end
      end

     # PATCH/PUT /wings/:id
        def update
          # binding.pry
          @wings = MgWing.find(params[:id])
          if @wings.update(wing_params)
            render json: { message: "Academic year updated"}, status: :created
          end
        end
        # DELETE /wings/:id
        def destroy
          @wings = MgWing.find_by(id: params[:id], mg_school_id: session[:current_user_school_id], is_deleted: 0)
          if @wings.present?
            @wings.update(is_deleted: 1) # Soft delete by updating the is_deleted flag
            render json: { message: 'Academic year deleted successfully' }, status: :ok
          else
            render json: { errors: 'Academic year not found or already deleted' }, status: :not_found
          end
        end
        private
        def wing_params
          params.require(:wings).permit(:wing_name, :status, :created_by, :updated_by, :is_deleted, :mg_school_id)
        end
      
end


# class WingsController < ApplicationController
#   layout "mindcom"

#   def index
#     @wings = MgWing.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])
#   end

#   def create
#     @wings = MgWing.new(wing_params)
#     if @wings.save
#       redirect_to action: "index"
#     end
#   end

#   def wing_edit
#     @wings = MgWing.find(params[:id])
#   end

#   def wing_delete
#     @wings = MgWing.find(params[:id])
#     boolVal = MgDependancyClass.wing_dependancy("mg_wing_id", params[:id])
    
#     if boolVal
#       flash[:error] = "Cannot Delete this Wing is Having Dependencies"
#     else
#       @wings.update(is_deleted: 1)
#       flash[:notice] = "Deleted Successfully"
#     end

#     redirect_to action: "index"
#   end

#   def new
#   end

#   def wing_update
#     @wings = MgWing.find(params[:id])
#     if @wings.update(wing_params)
#       redirect_to action: "index"
#     end
#   end

#   def show
#   end

#   private

#   def wing_params
#     params.require(:wings).permit(:wing_name, :status, :created_by, :updated_by, :is_deleted, :mg_school_id)
#   end
# end
