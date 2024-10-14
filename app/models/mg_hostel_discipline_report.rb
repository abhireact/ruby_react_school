class MgHostelDisciplineReport < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_hostel_discipline_report_list)
end
