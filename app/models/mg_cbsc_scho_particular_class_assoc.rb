class MgCbscSchoParticularClassAssoc < ApplicationRecord
  belongs_to(:mg_course)
  belongs_to(:mg_batch)
  belongs_to(:mg_scholastic_exam_particular)
end
