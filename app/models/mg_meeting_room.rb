class MgMeetingRoom < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee)
  has_many :mg_meeting_deatails,  dependent: :destroy 
  has_many :mg_employees,  through: :mg_meeting_deatails, dependent: :destroy 
end
