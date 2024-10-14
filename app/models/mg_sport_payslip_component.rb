class MgSportPayslipComponent < ApplicationRecord
  belongs_to(:mg_employee_payslip_detail)
  belongs_to(:mg_school)
  has_many :mg_sports_pay_deductions,  dependent: :destroy 
end
