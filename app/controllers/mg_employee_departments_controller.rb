class MgEmployeeDepartmentsController < ApplicationController
  before_action :login_required
  layout "mindcom"

  def index
    @employee_departments = MgEmployeeDepartment.where(is_deleted: '0', mg_school_id: session[:current_user_school_id])
  end

  def new
    @employee_department = MgEmployeeDepartment.new
  end

  def create
    @emp_dep = MgEmployeeDepartment.new(employee_department_params)
    @emp_dep.mg_school_id = session[:current_user_school_id]
    @emp_dep.is_deleted = 0
    if @emp_dep.save
      render json: { message: 'Department created successfully.', department: @emp_dep }, status: :created
    else
      render json: { errors: @emp_dep.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @art = MgEmployeeDepartment.where(is_deleted: '0', mg_school_id: session[:current_user_school_id])
  end

  def edit
    @employee_department = MgEmployeeDepartment.find(params[:id])
    @id = params[:id]
  end

  def update
    @employee_department = MgEmployeeDepartment.find(params[:id])
    if @employee_department.update(employee_department_params)
      render json: { message: 'Department updated successfully.', department: @employee_department }, status: :ok
    else
      render json: { errors: @employee_department.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def delete
    @employee_department = MgEmployeeDepartment.find(params[:id])
    boolvalue = MgDependancyClass.employeeDepartment_dependancy("mg_employee_department_id", params[:id])
    if  boolvalue[0].present?
      render json: { error: "Cannot delete, this department has dependencies." }, status: :forbidden
    else
      @employee_department.update(is_deleted: 1)
      render json: { message: "Deleted successfully." }, status: :ok
    end
    # redirect_to mg_employee_departments_path
  end

  def destroy
    @employee_department = MgEmployeeDepartment.find(params[:id])
    
    if @employee_department.destroy
      render json: { message: 'Department deleted successfully.' }, status: :ok
    else
      render json: { error: 'Failed to delete department.' }, status: :unprocessable_entity
    end
  end

  private

  def employee_department_params
    params.require(:mg_employee_department).permit(:department_name, :department_code, :status, :is_deleted, :mg_school_id)
  end
end
