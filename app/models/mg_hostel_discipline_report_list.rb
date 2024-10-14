class MgHostelDisciplineReportList < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_student)
  has_many :mg_hostel_discipline_reports,  dependent: :destroy 
end
