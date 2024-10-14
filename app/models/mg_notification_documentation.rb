class MgNotificationDocumentation < ApplicationRecord
  belongs_to(:mg_school)
  has_attached_file(:file)
  validates_attachment_content_type(:file, { content_type: [] })
end
