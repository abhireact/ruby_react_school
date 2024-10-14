class MgExaminationAbsentReason < ApplicationRecord
  belongs_to(:mg_school)
  validates(:name, { presence: true })
  validates(:code, { length: { in: 1..3 } })
end
