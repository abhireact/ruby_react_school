class MgTransferCertificate < ApplicationRecord
  store(:student_performance, { coder: JSON })
end
