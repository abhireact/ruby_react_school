class MgBankDetail < ApplicationRecord
  validates(:beneficiary, :bank_name, :account_number, :ifsc_code, { presence: true })
  validates(:account_number, { numericality: true })
end
