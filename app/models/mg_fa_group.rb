class MgFaGroup < ApplicationRecord
  belongs_to(:mg_cce_exam_category)
  belongs_to(:mg_cce_grade_set)
  belongs_to(:mg_school)
  has_many :mg_fa_criterias,  dependent: :destroy 
  has_many :mg_fa_groups_subjects,  dependent: :destroy 
end
