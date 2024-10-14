class MgExcessFeeCollection < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_student)
  validates(:mg_student_id, { uniqueness: { scope: :mg_school_id, conditions: lambda {
    where({ is_deleted: false })
  } } })
end
