class MgGuardianTransportRequisition < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_vehicle)
  belongs_to(:mg_student)
  belongs_to(:mg_transport_time_management)
  belongs_to(:mg_transport)
end
