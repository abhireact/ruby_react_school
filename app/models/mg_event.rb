class MgEvent < ApplicationRecord
  belongs_to(:mg_event_type)
  belongs_to(:mg_school)
  has_many :mg_event_committees,  dependent: :destroy 
  has_many :mg_exams,  dependent: :destroy 
  has_many :mg_exam_groups,  through: :mg_exams, dependent: :destroy 
  has_many :mg_event_privacy,  dependent: :destroy 
  has_many :mg_albums,  dependent: :destroy 
  has_many :mg_guests,  dependent: :destroy 
  has_many :mg_invitations,  dependent: :destroy 
  has_many :mg_sports_results,  dependent: :destroy 
end
