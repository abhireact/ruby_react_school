class MgObservationGroup < ApplicationRecord
  belongs_to(:mg_cce_grades_set)
  belongs_to(:mg_school)
  has_many :mg_course_observation_groups,  dependent: :destroy 
  has_many :mg_observations,  dependent: :destroy 
  has_many :courses,  through: :mg_course_observation_groups, dependent: :destroy 
end
