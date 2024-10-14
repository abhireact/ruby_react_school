class MgHostelDetails < ApplicationRecord
  belongs_to(:mg_school)
  has_one :mg_hostel_warden,  dependent: :destroy 
  has_many :mg_hostel_attendances,  dependent: :destroy 
  has_many :mg_complain_hostels,  dependent: :destroy 
  has_many :mg_students,  through: :mg_complain_hostels, dependent: :destroy 
  has_one :mg_employee,  through: :mg_hostel_warden, dependent: :destroy 
  has_many :mg_users,  through: :mg_allocate_rooms, dependent: :destroy 
  has_many :mg_users,  through: :mg_hostel_wardens, dependent: :destroy 
  has_many :mg_users,  through: :mg_hostel_floors, dependent: :destroy 
end
