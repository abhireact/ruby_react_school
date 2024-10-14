class MgEmployeeLeaveType < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee_type)
  has_many :mg_employee_leave_applications,  dependent: :destroy 
  has_many :mg_employees,  through: :mg_employee_leave_applications, dependent: :destroy 
  has_many :mg_payslip_leave_details,  dependent: :destroy 
  has_many :mg_employee_attendances,  dependent: :destroy 
end
