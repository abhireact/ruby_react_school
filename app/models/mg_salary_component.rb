class MgSalaryComponent < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_account)
  has_many :mg_grade_components,  dependent: :destroy 
  has_many :mg_employee_grade_components,  dependent: :destroy 
  has_many :mg_employees,  through: :mg_employee_grade_components, dependent: :destroy 
  has_many :mg_employee_payslip_components,  dependent: :destroy 
end
