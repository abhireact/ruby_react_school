class MgHostelGoingOutProvision < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_student)
end
