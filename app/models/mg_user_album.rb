class MgUserAlbum < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_album)
  belongs_to(:mg_employee_department)
  belongs_to(:mg_batch)
end
