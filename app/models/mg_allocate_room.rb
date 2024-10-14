class MgAllocateRoom < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_user)
  belongs_to(:mg_hostel_detail)
  belongs_to(:mg_wing)
  has_many :mg_allocate_room_lists,  dependent: :destroy 
  has_many :mg_hostel_floors,  through: :mg_allocate_room_lists, dependent: :destroy 
  has_many :mg_students,  through: :mg_allocate_room_lists, dependent: :destroy 
end
