class MgAccount < ApplicationRecord
  validates(:mg_account_name, { uniqueness: { scope: :mg_school_id, conditions: lambda {
    where({ is_deleted: false })
  } } })
  belongs_to(:mg_school)
  has_many :mg_fee_categories,  dependent: :destroy 
  has_many :mg_fee_fine_particulars,  dependent: :destroy 
  has_many :mg_fee_particulars,  dependent: :destroy 
  has_many :mg_master_payment_types,  dependent: :destroy 
  has_many :mg_payment_gateways,  dependent: :destroy 
  has_many :mg_salary_components,  dependent: :destroy 
  has_many :mg_sports_fines,  dependent: :destroy 
  belongs_to(:mg_employee)
  belongs_to(:mg_user)
end
