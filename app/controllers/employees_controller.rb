class EmployeesController < ApplicationController
    layout "mindcom"
  

  def index
    # Fetch all employees where `is_deleted` is 0
    @employees = MgEmployee.where(is_deleted: 0)
  end

def create
 
    @employee = MgEmployee.new(employee_params)
    if @employee.save
      render json: @employee, status: :created
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  def update
  end

  def delete
  end
    def employee_params
    params.require(:employee).permit(
      :first_name, 
      :last_name, 

    )
  end
end
