class MgAlumniProgrammeAttended < ApplicationRecord
  belongs_to(:mg_wing)
  delegate :wing_name, to: :mg_wing
  has_many :mg_alumins,  dependent: :destroy 
  belongs_to(:mg_school)
  belongs_to(:mg_document_management)
end
