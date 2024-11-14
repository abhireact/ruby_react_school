# class WingsController < ApplicationController
#   layout "mindcom"

#   def index
#     @wings = MgWing.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])
    
#     # Check if it's an API request (via format or params)
#     respond_to do |format|
#       format.html # renders the default index.html.erb
#       format.json do
#         if params[:api_request].present?
#           render json: @wings, status: :created
#         else
#           render json: { error: "API request parameter missing" }, status: :bad_request
#         end
#       end
#     end
#   end

#   # POST /wings
#   def create
#       @wings = MgWing.new(wing_params)
#       @wings.mg_school_id = session[:current_user_school_id]
#       @wings.is_deleted= 0
#       @wings.created_by= session[:user_id]
#       @wings.updated_by= session[:user_id]
#       if @wings.save
#         render json: { message: "Academic year Created"}, status: :created
#       end
#   end

#      # PATCH/PUT /wings/:id
#         def update
#           # binding.pry
#           @wings = MgWing.find(params[:id])
#           if @wings.update(wing_params)
#             render json: { message: "Academic year updated"}, status: :created
#           end
#         end
#         # DELETE /wings/:id
#         def destroy
#           @wings = MgWing.find_by(id: params[:id], mg_school_id: session[:current_user_school_id], is_deleted: 0)
#           if @wings.present?
#             @wings.update(is_deleted: 1) # Soft delete by updating the is_deleted flag
#             render json: { message: 'Academic year deleted successfully' }, status: :ok
#           else
#             render json: { errors: 'Academic year not found or already deleted' }, status: :not_found
#           end
#         end
#         private
#         def wing_params
#           params.require(:wings).permit(:wing_name, :status, :created_by, :updated_by, :is_deleted, :mg_school_id)
#         end
      
# end

class WingsController < ApplicationController
  include JsonResponseHelper  # Include the helper module

  layout "mindcom"
  
  before_action :set_wing, only: [:update, :destroy]

  # GET /wings
  def index
    @wings = MgWing.where(is_deleted: 0, mg_school_id: current_school_id)
    async_action do
      respond_to do |format|
        format.html # renders the default index.html.erb
        format.json do
          if params[:api_request].present?
            render_json_response(@wings, :ok)
          else
            render_json_response({ error: "API request parameter missing" }, :bad_request)
          end
        end
      end
    end
  end

  # POST /wings
  def create
    async_action do
      @wing = MgWing.new(wing_params.merge(
        mg_school_id: current_school_id,
        is_deleted: 0,
        created_by: current_user_id,
        updated_by: current_user_id
      ))

      if @wing.save
        render_json_response({ message: "Wings created successfully" }, :created)
      else
        render_json_response({ errors: @wing.errors.full_messages }, :unprocessable_entity)
      end
    end
  end

  # PATCH/PUT /wings/:id
 def update
  begin
    Rails.logger.info "Params received: #{params.inspect}"

    async_action do
      if @wing.update(wing_params.merge(updated_by: current_user_id))
        Rails.logger.info "Wing updated successfully for ID #{params[:id]}"
        render_json_response({ message: "Wing updated successfully" }, :ok)
      else
        Rails.logger.error "Failed to update wing with ID #{params[:id]}, errors: #{@wing.errors.full_messages}"
        render_json_response({ errors: @wing.errors.full_messages }, :unprocessable_entity)
      end
    end
  rescue ActionController::ParameterMissing => e
    # If required parameters are missing, send error response
    Rails.logger.error "Missing parameter: #{e.message}"
    render_json_response({ errors: ["Missing required parameter: #{e.message}"] }, :unprocessable_entity)
  rescue ActionController::UnpermittedParameters => e
    # If there are unpermitted parameters
    Rails.logger.error "Unpermitted parameter: #{e.message}"
    render_json_response({ errors: ["Unpermitted parameter: #{e.message}"] }, :unprocessable_entity)
  end
 end


  # DELETE /wings/:id
  def destroy
    async_action do
      if @wing.present? && @wing.update(is_deleted: 1)
        render_json_response({ message: "Academic year deleted successfully" }, :ok)
      else
        render_json_response({ error: "Academic year not found or already deleted" }, :not_found)
      end
    end
  end

  private

  # Set the wing object based on the ID parameter
  def set_wing
    @wing = MgWing.find_by(id: params[:id], mg_school_id: current_school_id, is_deleted: 0)
    render_json_response({ error: "Wings not found" }, :not_found) unless @wing
  end

  # Strong parameters for wings
def wing_params
  # Ensure that params[:wings] is present and then permit the necessary fields
  params.require(:wings).permit(:id, :wing_name, :status, :is_deleted, :mg_school_id, :created_by, :updated_by, :created_at, :updated_at)
end


  # Current school ID from session
  def current_school_id
    session[:current_user_school_id]
  end

  # Current user ID from session
  def current_user_id
    session[:user_id]
  end
end
