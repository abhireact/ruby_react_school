class MgCurriculum < ApplicationRecord
  belongs_to(:mg_user)
  belongs_to(:mg_subject)
  belongs_to(:mg_topic)
  belongs_to(:mg_school)
end
