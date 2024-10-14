class MgPaymentType < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_add_reports,  dependent: :destroy 
  has_many :mg_vehicles,  through: :mg_add_reports, dependent: :destroy 
end
