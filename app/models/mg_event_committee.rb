class MgEventCommittee < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_event)
  has_many :mg_committee_members,  dependent: :destroy 
  has_many :mg_employees,  through: :mg_committee_members, dependent: :destroy 
  has_many :mg_students,  through: :mg_committee_members, dependent: :destroy 
  has_many :mg_sports_results,  dependent: :destroy 
end
