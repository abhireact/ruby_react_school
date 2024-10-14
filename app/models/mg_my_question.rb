class MgMyQuestion < ApplicationRecord
  belongs_to(:mg_batch)
  belongs_to(:mg_school)
  belongs_to(:mg_employee)
  belongs_to(:mg_batch_content)
end
