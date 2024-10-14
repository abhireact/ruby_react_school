class MgOnlineMeeting < ApplicationRecord
  belongs_to(:mg_batch_subjects)
  belongs_to(:mg_batch)
end
