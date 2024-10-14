class MgDisciplinaryAction < ApplicationRecord
  belongs_to(:mg_wing)
  belongs_to(:mg_school)
  has_many :mg_disciplinary_action_students,  dependent: :destroy 
  belongs_to(:mg_student)
end
