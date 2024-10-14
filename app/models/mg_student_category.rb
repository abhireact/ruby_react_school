class MgStudentCategory < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_fee_fine_particulars,  dependent: :destroy 
  has_many :mg_fee_particulars,  dependent: :destroy 
  has_many :mg_fee_collection_particulars,  dependent: :destroy 
  has_many :mg_student_admissions,  dependent: :destroy 
  has_many :mg_students,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_students)
  validates(:name, { uniqueness: { scope: :mg_school_id, case_sensitive: false, conditions: lambda {
    where({ is_deleted: false })
  } } })
end
