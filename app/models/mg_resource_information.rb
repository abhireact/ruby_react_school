class MgResourceInformation < ApplicationRecord
  belongs_to(:mg_resource_type)
  belongs_to(:mg_resource_category)
  belongs_to(:mg_school)
  belongs_to(:mg_subject)
  belongs_to(:mg_course)
  belongs_to(:mg_resource_purchase)
  before_save(:strip_whitespace)

  def strip_whitespace
    unless self.name.nil?
      self.name=self.name.strip
    end
  end
end
