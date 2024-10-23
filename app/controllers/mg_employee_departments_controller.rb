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
    if @emp_dep.save
      redirect_to mg_employee_departments_path, notice: 'Department created successfully.'
    else
      render :new
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
      redirect_to mg_employee_departments_path, notice: 'Department updated successfully.'
    else
      render :edit
    end
  end

  def delete
    @employee_department = MgEmployeeDepartment.find(params[:id])
    if MgDependancyClass.employeeDepartment_dependancy("mg_employee_department_id", params[:id])
      flash[:error] = "Cannot delete, this department has dependencies."
    else
      @employee_department.update(is_deleted: 1)
      flash[:notice] = "Deleted successfully."
    end
    redirect_to mg_employee_departments_path
  end

  def destroy
    @employee_department = MgEmployeeDepartment.find(params[:id])
    @employee_department.destroy
    redirect_to mg_employee_departments_show_path, notice: 'Department deleted successfully.'
  end

  private

  def employee_department_params
    params.require(:mg_employee_department).permit(:department_name, :department_code, :status, :is_deleted, :mg_school_id)
  end
end
