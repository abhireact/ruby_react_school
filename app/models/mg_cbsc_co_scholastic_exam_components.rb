class MgCbscCoScholasticExamComponents < ApplicationRecord
  belongs_to(:mg_School)
  has_many :mg_cbsc_co_scholastic_exam_particulars,  foreign_key: "mg_cbsc_co_scholastic_exam_component_id", class_name: "MgCbscCoScholasticExamParticular", dependent: :destroy 
  validates(:index, { uniqueness: { scope: [:mg_school_id, :mg_time_table_id], allow_blank: true, allow_nil: true, conditions: lambda {
    where({ is_deleted: false })
  } } })
end
