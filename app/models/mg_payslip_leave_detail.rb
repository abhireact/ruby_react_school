class MgPayslipLeaveDetail < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee_leave_type)
  belongs_to(:mg_employee_payslip_detail)
end
