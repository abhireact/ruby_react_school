class MgSectionDetails < ApplicationRecord
  belongs_to(:mg_create_question_paper)
  belongs_to(:mg_school)
end
