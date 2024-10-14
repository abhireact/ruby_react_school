class MgHomeworkCategory < ApplicationRecord
  has_many :mg_assignments,  dependent: :destroy 
  belongs_to(:mg_school)
end
