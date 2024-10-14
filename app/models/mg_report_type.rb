class MgReportType < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_add_reports,  dependent: :destroy 
end
