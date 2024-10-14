class MgHostelFloor < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_user)
  belongs_to(:mg_hostel_detail)
  has_many :mg_allocate_room_lists,  dependent: :destroy 
  has_many :mg_allocate_rooms,  through: :mg_allocate_room_lists, dependent: :destroy 
  has_many :mg_hostel_health_managements,  dependent: :destroy 
  has_many :mg_hostel_reallotment_requests,  dependent: :destroy 
  has_many :mg_hostel_rooms,  dependent: :destroy 
  validates(:name, { uniqueness: { scope: :mg_school_id, conditions: lambda {
    where({ is_deleted: false })
  } } })
end
