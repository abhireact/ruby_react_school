class MgCompanyDetail < ApplicationRecord
  validates(:name, :code, :address_line1, :city, :pin_code, :state, :country, :status, { presence: true })
  validates(:code, { uniqueness: true })
end
