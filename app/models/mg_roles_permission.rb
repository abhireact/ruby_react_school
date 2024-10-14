class MgRolesPermission < ApplicationRecord
  belongs_to(:mg_permission)
  belongs_to(:mg_role)
  belongs_to(:mg_school)
end
