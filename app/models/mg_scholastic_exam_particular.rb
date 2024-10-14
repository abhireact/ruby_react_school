class MgScholasticExamParticular < ApplicationRecord
  has_many :mg_cbsc_exam_schedules,  dependent: :destroy 
  has_many :mg_cbsc_scholastic_marks_entries,  dependent: :destroy 
  has_many :mg_final_scholastic_scores,  dependent: :destroy 
  has_many :mg_scholastic_exam_components,  dependent: :destroy 
  has_many :mg_students,  through: :mg_final_scholastic_scores, dependent: :destroy 
  has_many :mg_cbsc_scho_particular_class_assoc,  dependent: :destroy 
  validates(:index, { uniqueness: { scope: [:mg_school_id, :mg_time_table_id], allow_blank: true, allow_nil: true, conditions: lambda {
    where({ is_deleted: false })
  } } })
  belongs_to(:mg_school)

  def absent_reason=(value)
    super(value.to_json)
  end

  def absent_reason
    value = super
    if (value != "null") && value.present?
      JSON.parse(value)
    else
      []
    end
  end
end
