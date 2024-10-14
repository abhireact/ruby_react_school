class MgAlumniPolling < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_poll_option_alumni)
end
