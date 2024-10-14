class MgInvoiceGeneration < ApplicationRecord
  validates(:mg_financial_year_id, :mg_school_id, :temporary_date_of_invoice, { presence: true })
  belongs_to(:mg_school, lambda {
    where({ is_deleted: 0 })
  })
  has_many :mg_invoice_associations,  dependent: :destroy 
end
