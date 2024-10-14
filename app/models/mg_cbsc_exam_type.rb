class MgCbscExamType < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_cbsc_exam_type_associations,  dependent: :destroy 
  has_many :mg_courses,  through: :mg_cbsc_exam_type_associations, dependent: :destroy 
  has_many :mg_batches,  through: :mg_cbsc_exam_type_associations, dependent: :destroy 
  has_many :mg_cbsc_final_co_scholastic_grades,  dependent: :destroy 
  has_many :mg_students,  through: :mg_cbsc_final_co_scholastic_grades, dependent: :destroy 
  has_many :mg_cbsc_other_marks_entries,  dependent: :destroy 
  has_many :mg_students,  through: :mg_cbsc_other_marks_entries, dependent: :destroy 
  has_many :mg_cbsc_scholastic_marks_entries,  dependent: :destroy 
  has_many :mg_batches,  through: :mg_cbsc_scholastic_marks_entries, dependent: :destroy 
  has_many :mg_final_scholastic_scores,  dependent: :destroy 
  validates(:index, { uniqueness: { scope: [:mg_school_id, :mg_time_table_id], allow_blank: true, allow_nil: true, conditions: lambda {
    where({ is_deleted: false })
  } } })
  validates(:exam_type_name, { uniqueness: { scope: [:mg_school_id, :mg_time_table_id], conditions: lambda {
    where({ is_deleted: false })
  } } })
end
