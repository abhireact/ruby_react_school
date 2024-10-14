class MgCceWeightages < ApplicationRecord
  belongs_to(:mg_cce_exam_category)
  belongs_to(:mg_school)
  has_many :mg_cce_weightages_courses,  dependent: :destroy 
end
