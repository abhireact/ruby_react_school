class MgGetTogether < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_alumni)
end
