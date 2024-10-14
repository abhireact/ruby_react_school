class MgAllocateRoomList < ApplicationRecord
  belongs_to(:mg_student)
  belongs_to(:mg_allocate_room)
  belongs_to(:mg_school)
  belongs_to(:mg_hostel_floor)
  belongs_to(:mg_hostel_room_type)
  has_many :mg_hostel_rooms,  dependent: :destroy 
end
