class MgVehicle < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee_category)
  belongs_to(:mg_employee)
  belongs_to(:mg_transport)
  belongs_to(:mg_employee_position)
  has_many :mg_add_reports,  dependent: :destroy 
  has_many :mg_payment_types,  through: :mg_add_reports, dependent: :destroy 
  has_many :mg_guardian_transport_requisitions,  dependent: :destroy 
  has_many :mg_students,  through: :mg_guardian_transport_requisitions, dependent: :destroy 
  belongs_to(:mg_transport)
  has_attached_file(:file)
end
