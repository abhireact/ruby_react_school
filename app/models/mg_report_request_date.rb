class MgReportRequestDate < ApplicationRecord
  belongs_to(:mg_time_table)
  belongs_to(:mg_batch)
  belongs_to(:mg_school)
end
