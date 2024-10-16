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

private

def school_params
  params.require(:school).permit(
    :school_name, :school_code, :start_time, :end_time, 
    :reg_num, :mobile_number, :email_id, 
    :address_line1, :address_line2, :street, :city, 
    :state, :pin_code, :landmark, :country
  )
end

end
