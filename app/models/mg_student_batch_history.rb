class MgStudentBatchHistory < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_student)
  belongs_to :mg_time_table,  foreign_key: "to_academic_year", primary_key: "id" 
  belongs_to :mg_batch,  foreign_key: "to_section_id", primary_key: "id" 
end
