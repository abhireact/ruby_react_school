class MgSibling < ApplicationRecord
  belongs_to(:mg_batch)
  belongs_to(:mg_school)
  belongs_to(:mg_course)
  belongs_to(:mg_user)
end
