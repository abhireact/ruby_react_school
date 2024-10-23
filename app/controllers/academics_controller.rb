class AcademicsController < ApplicationController
    layout "mindcom"


def index
  @academic_years= MgTimeTable.where(mg_school_id:session[:current_user_school_id],is_deleted:0)
 end
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

private
def academic_params
  params.require(:academic_years).permit(:name, :start_date, :end_date, :is_deleted)
end
end
