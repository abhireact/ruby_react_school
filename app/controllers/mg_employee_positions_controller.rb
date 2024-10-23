class MgEmployeePositionsController < ApplicationController
  before_action :login_required
  layout "mindcom"
  
  def index
    @employee_positions = MgEmployeePosition.where(is_deleted: '0', mg_school_id: session[:current_user_school_id])
  end

  def new
    @employee_position = MgEmployeePosition.new
  end

  def create
    @emp_pos = MgEmployeePosition.new(employee_position_params)
    if @emp_pos.save
      redirect_to mg_employee_positions_path, notice: 'Position created successfully.'
    else
      render :new
    end
  end

  def edit
    @employee_position = MgEmployeePosition.find(params[:id])
    @id = params[:id]
  end

  def update
    @employee_position = MgEmployeePosition.find(params[:id])
    if @employee_position.update(employee_position_params)
      redirect_to mg_employee_positions_path, notice: 'Position updated successfully.'
    else
      render :edit
    end
  end

  def delete
    @employee_position = MgEmployeePosition.find(params[:id])
    @employees = MgEmployee.where(is_deleted: 0, mg_school_id: session[:current_user_school_id], mg_employee_position_id: params[:id])
    boolVal = MgDependancyClass.employeePosition_dependancy("mg_employee_position_id", params[:id])
    if boolVal
      flash[:notice] = "Cannot delete, this employee profile has dependencies."
    else
      @employee_position.update(is_deleted: 1)
      flash[:notice] = "Deleted successfully."
    end
    redirect_to mg_employee_positions_path
  end

  def destroy
    @employee_position = MgEmployeePosition.find(params[:id])
    @employee_position.destroy
    redirect_to mg_employee_positions_path, notice: 'Position deleted successfully.'
  end

  private

  def employee_position_params
    params.require(:mg_employee_position).permit(:mg_employee_category_id, :position_name, :status, :is_deleted, :mg_school_id)
  end

  def update_param
    params.require(:article).permit(:mg_employee_category_id, :position_name, :status, :mg_school_id)
  end

end
