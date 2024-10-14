class MgEntranceExamVenue < ApplicationRecord
  belongs_to(:mg_school)
  validates(:institute_name, { uniqueness: { scope: :institute_name, conditions: lambda {
    where({ is_deleted: false })
  } } })
end
