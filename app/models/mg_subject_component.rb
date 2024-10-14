class MgSubjectComponent < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_time_table)
  belongs_to(:mg_course)
  belongs_to(:mg_batch)
  belongs_to(:mg_subject)
  validates(:subject_component_name, { presence: true })
end
