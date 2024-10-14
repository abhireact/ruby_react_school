class MgEmployeeDepartment < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_employee_attendances,  dependent: :destroy 
  has_many :mg_account_central_incharges,  dependent: :destroy 
  has_many :mg_albums,  dependent: :destroy 
  has_many :mg_allergies,  dependent: :destroy 
  has_many :mg_employees,  dependent: :restrict_with_exception 
  has_many :mg_canteen_wallet_amounts,  dependent: :destroy 
  has_many :mg_finance_officers,  dependent: :destroy 
  has_many :mg_check_up_schedule_records,  dependent: :destroy 
  has_many :mg_employee_holiday_attendances,  dependent: :destroy 
  has_many :mg_health_tests,  dependent: :destroy 
  has_many :mg_hostel_wardens,  dependent: :destroy 
  has_many :mg_inventory_store_managers,  dependent: :destroy 
  has_many :mg_invitations,  dependent: :destroy 
  has_many :mg_postal_records,  dependent: :destroy 
  has_many :mg_sports_pay_deductions,  dependent: :destroy 
  has_many :mg_user_albums,  dependent: :destroy 
  has_many :mg_canteen_bill_details,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_employees)
end
