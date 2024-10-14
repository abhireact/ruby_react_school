class MgUserRole < ApplicationRecord
  belongs_to(:mg_role)
  belongs_to(:mg_user)
end
