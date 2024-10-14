class MgSportsAssociation < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_sport)
  belongs_to(:mg_user)
end
