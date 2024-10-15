class SchoolsController < ApplicationController
    layout "mindcom"
  
  def index
    #  redirect_to :action=>'show', :id=>session[:current_user_school_id]
    @school = MgSchool.where(id:session[:current_user_school_id],is_deleted:0)
    
  end
  def update
    @school = MgSchool.find_by(id: session[:current_user_school_id], is_deleted: 0)
    if @school
      if @school.update(school_params)
        render json: @school, status: :ok
      else
        render json: { errors: @school.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "School not found" }, status: :not_found
    end
  end
  def academic
    @academic_years= MgTimeTable.where(mg_school_id:session[:current_user_school_id],is_deleted:0)
   end


    # POST /academic_years
  def create
    @academic_year = MgTimeTable.new(academic_params)
    @academic_year.mg_school_id = session[:current_user_school_id] # Assuming this links it to the current school
    @academic_year.is_deleted= 0
    @academic_year.created_by = session[:user_id] # Assuming this links it to the current school
    @academic_year.updated_by = session[:user_id] # Assuming this links it to the current school

    if @academic_year.save
      render json: @academic_year, status: :created
    else
      render json: { errors: @academic_year.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /academic_years/:id
  def update
    @academic_year = MgTimeTable.find_by(id: params[:id], mg_school_id: session[:current_user_school_id], is_deleted: 0)
    if @academic_year.update(academic_params)
      render json: @academic_year, status: :ok
    else
      render json: { errors: @academic_year.errors.full_messages }, status: :unprocessable_entity
    end
  end
# DELETE /academic_years/:id
def destroy
  @academic_year = MgTimeTable.find_by(id: params[:id], mg_school_id: session[:current_user_school_id], is_deleted: 0)

  if @academic_year.present?
    @academic_year.update(is_deleted: 1) # Soft delete by updating the is_deleted flag
    render json: { message: 'Academic year deleted successfully' }, status: :ok
  else
    render json: { errors: 'Academic year not found or already deleted' }, status: :not_found
  end
end

    # get /wings

  
  private
  def academic_params
    params.require(:academic_years).permit! #(:name, :start_date, :end_date, :is_deleted)
  end
  private
  
  def school_params
    params.require(:school).permit(
      :school_name, :school_code, :start_time, :end_time, 
      :reg_num, :mobile_number, :email_id, 
      :address_line1, :address_line2, :street, :city, 
      :state, :pin_code, :landmark, :country
    )
  end
  private
  def wing_params
    params.require(:wings).permit(:wing_name, :status, :created_by, :updated_by, :is_deleted, :mg_school_id)
  end

end
 