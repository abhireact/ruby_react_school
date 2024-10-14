class MgCanteenBillDetail < ApplicationRecord
  belongs_to(:mg_employee)
  belongs_to(:mg_employee_department)
  belongs_to(:mg_batch)
  belongs_to(:mg_school)
  belongs_to(:mg_user)
  belongs_to(:mg_student)
  has_many :mg_canteen_bill_payments,  dependent: :destroy 
  has_many :mg_canteen_balance_amounts,  dependent: :destroy 

  def destroy
  end
end
