class MgAdmissionSetting < ApplicationRecord
  validates(:mg_time_table_id, { uniqueness: { scope: [:mg_school_id, :mg_time_table_id, :is_deleted] } })
end
