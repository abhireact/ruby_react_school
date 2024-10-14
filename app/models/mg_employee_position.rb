class MgEmployeePosition < ApplicationRecord
  belongs_to(:mg_employee_category)
  belongs_to(:mg_school)
  has_many :mg_transports,  dependent: :destroy 
  has_many :mg_vehicles,  dependent: :destroy 
  has_many :mg_fom_transport_bookings,  dependent: :destroy 
  has_many :mg_guest_room_bookings,  dependent: :destroy 
  has_many :mg_employees,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_employees)
end
