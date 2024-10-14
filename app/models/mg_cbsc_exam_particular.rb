class MgCbscExamParticular < ApplicationRecord
  belongs_to(:mg_school)
  validates(:name, { uniqueness: { scope: :exam_type_id, conditions: lambda {
    where({ is_deleted: false })
  } } })
end
