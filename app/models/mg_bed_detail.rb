class MgBedDetail < ApplicationRecord
  belongs_to(:mg_school)
  validates(:bed_no, { uniqueness: { scope: :mg_school_id, conditions: lambda {
    where({ is_deleted: false })
  } } })
end
