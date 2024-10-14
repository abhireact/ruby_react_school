class MgHostelRoom < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_hostel_floor)
  belongs_to(:mg_hostel_room_type)
  belongs_to(:mg_allocate_room_list)
  has_many :mg_hostel_health_managements,  dependent: :destroy 
  has_many :mg_hostel_reallotment_requests,  dependent: :destroy 
end
