class MgCceGradesSet < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_cce_grades,  dependent: :destroy 
  has_many :mg_fa_groups,  dependent: :destroy 
  has_many :mg_observation_groups,  dependent: :destroy 
end
