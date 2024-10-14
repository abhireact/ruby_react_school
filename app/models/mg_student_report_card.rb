class MgStudentReportCard < ApplicationRecord
  store(:report_details, { coder: JSON })
  store(:rank_details, { coder: JSON })
end
