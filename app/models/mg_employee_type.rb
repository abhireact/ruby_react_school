class MgEmployeeType < ApplicationRecord
  has_many :mg_employee_leave_types,  dependent: :destroy 
  has_many :mg_employees,  dependent: :destroy 
  belongs_to(:mg_school)
end
