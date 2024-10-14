class MgEmployeePayslipDetail < ApplicationRecord
  has_many :mg_employee_payslip_components,  dependent: :destroy 
  belongs_to(:mg_employee)
  belongs_to(:mg_school)
  has_many :mg_payslip_leave_details,  dependent: :destroy 
  has_many :mg_sport_payslip_components,  dependent: :destroy 
end
