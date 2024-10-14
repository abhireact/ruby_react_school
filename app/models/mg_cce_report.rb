class MgCceReport < ApplicationRecord
  belongs_to(:mg_batch)
  belongs_to(:mg_student)
  belongs_to(:mg_exam)
  scope(:scholastic, lambda {
    where({ observable_type: "FaCriteria" })
  })
end
