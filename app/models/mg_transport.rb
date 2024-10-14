class MgTransport < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee_category)
  belongs_to(:mg_employee)
  belongs_to(:mg_employee_position)
  has_many :mg_vehicles,  dependent: :destroy 
  has_many :mg_guardian_transport_requisitions,  dependent: :destroy 
  has_many :mg_transport_time_managements,  dependent: :destroy 
  has_many :mg_vehicles,  dependent: :destroy 
end
