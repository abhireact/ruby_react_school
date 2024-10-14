class MgCceExamCategory < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_cce_weightages,  dependent: :destroy 
  has_many :mg_exam_groups,  dependent: :destroy 
  has_many :mg_fa_groups,  dependent: :destroy 
end
