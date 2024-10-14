class MgGuest < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_event)
end
