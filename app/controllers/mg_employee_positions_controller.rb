class MgEmployeePositionsController < ApplicationController
  include JsonResponseHelper # Include the concern
  before_action :login_required
  layout "mindcom"
  
  def index
    @employee_positions = MgEmployeePosition.where(is_deleted: '0', mg_school_id: session[:current_user_school_id])
    #react data 
    @employee_categories=MgEmployeeCategory.where(:is_deleted=>0).pluck(:category_name,:id)
    @react_data={positionData:@employee_positions,
  categoryData:@employee_categories}

  end

  def new
    @employee_position = MgEmployeePosition.new
  end

  def create
    @emp_pos = MgEmployeePosition.new(employee_position_params)
    @emp_pos.mg_school_id = session[:current_user_school_id]
    @emp_pos.is_deleted = 0
    if @emp_pos.save
      render json: { message: 'Position created successfully.', position: @emp_pos }, status: :created
    else
      render json: { errors: @emp_pos.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit
    @employee_position = MgEmployeePosition.find(params[:id])
    @id = params[:id]
  end

  def update
    @employee_position = MgEmployeePosition.find(params[:id])
    if @employee_position.update(employee_position_params)
      render json: { message: 'Position updated successfully.', position: @employee_position }, status: :ok
    else
    render json: { errors: @employee_position.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def delete
    @employee_position = MgEmployeePosition.find(params[:id])
    @employees = MgEmployee.where(is_deleted: 0, mg_school_id: session[:current_user_school_id], mg_employee_position_id: params[:id])
    boolVal = MgDependancyClass.employeePosition_dependancy("mg_employee_position_id", params[:id])
    if boolVal[0].present?
      render json: { message: "Cannot delete, this employee profile has dependencies." }, status: :forbidden
    else
      @employee_position.update(is_deleted: 1)
      render json: { message: "Deleted successfully." }, status: :ok
    end
    #redirect_to mg_employee_positions_path
  end

  def destroy
    @employee_position = MgEmployeePosition.find(params[:id])
    
    if @employee_position.destroy
      render json: { message: 'Position deleted successfully.' }, status: :ok
    else
      render json: { errors: 'Failed to delete the position.' }, status: :unprocessable_entity
    end
  end
  def show_positions
    @profiles_data = MgEmployeePosition.where(is_deleted: '0', mg_school_id: session[:current_user_school_id])
    
    render_json_response(@profiles_data)
    end
  

  private

  def employee_position_params
    params.require(:mg_employee_position).permit(:mg_employee_category_id, :position_name, :status, :is_deleted, :mg_school_id)
  end

  def update_param
    params.require(:article).permit(:mg_employee_category_id, :position_name, :status, :mg_school_id)
  end

end
