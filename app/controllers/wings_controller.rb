class WingsController < ApplicationController
  layout "mindcom"

  def index
    @wings = MgWing.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])
  end

  # POST /wings
  def create
    @wings = MgWing.new(wing_params)
    @wings.mg_school_id = session[:current_user_school_id]
    @wings.is_deleted = 0
    @wings.created_by = session[:user_id]
    @wings.updated_by = session[:user_id]
    if @wings.save
      redirect_to action: "index"
    end
  end

  # PATCH/PUT /wings/:id
def update
  @wings = MgWing.find(params[:id])
  
  if @wings.update(wing_params)
    # Fetch all wings after the update, similar to the index method
    all_wings = MgWing.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])
    
    # Return the updated wing and all wings in the response
    render json: { message: "Wing updated successfully", wing: @wings, wings: all_wings }, status: :ok
  else
    render json: { message: "Update failed", errors: @wings.errors.full_messages }, status: :unprocessable_entity
  end
end


  # DELETE /wings/:id
  def delete
    @wings = MgWing.find(params[:id])
    boolVal = MgDependancyClass.wing_dependancy("mg_wing_id", params[:id])

    if boolVal
      flash[:error] = "Cannot Delete this Wing is Having Dependencies"
    else
      @wings.update(is_deleted: 1)
      flash[:notice] = "Deleted Successfully"
    end

    redirect_to action: "index"
  end

  private

  def wing_params
    params.require(:wings).permit(:wing_name, :status, :created_by, :updated_by, :is_deleted, :mg_school_id)
  end
end
