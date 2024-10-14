class MgFaGroupsSubject < ApplicationRecord
  belongs_to(:mg_subject)
  belongs_to(:mg_fa_group)
  belongs_to(:mg_school)
end
