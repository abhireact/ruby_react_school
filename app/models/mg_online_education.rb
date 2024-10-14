class MgOnlineEducation < ApplicationRecord
  belongs_to(:mg_unit)
  belongs_to(:mg_subject)
  belongs_to(:mg_topic)
end
