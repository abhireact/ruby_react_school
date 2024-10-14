class MgHobbyAssociation < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_hobby)
  belongs_to(:mg_user)
end
