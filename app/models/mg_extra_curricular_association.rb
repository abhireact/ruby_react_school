class MgExtraCurricularAssociation < ApplicationRecord
  belongs_to(:mg_extra_curricular)
  belongs_to(:mg_school)
end
