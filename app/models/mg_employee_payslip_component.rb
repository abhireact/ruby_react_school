class MgEmployeePayslipComponent < ApplicationRecord
  belongs_to(:mg_employee_payslip_detail)
  belongs_to(:mg_salary_component)
  belongs_to(:mg_school)
end
