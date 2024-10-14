class MgAddReport < ApplicationRecord
  has_many :mg_document_managements,  dependent: :destroy 
  belongs_to(:mg_school)
  belongs_to(:mg_payment_type)
  belongs_to(:mg_vehicle)
  belongs_to(:mg_report_type)
end
