class MgManageSubject < ApplicationRecord
  belongs_to(:mg_school)
  before_save(:strip_whitespace)

  def strip_whitespace
    unless self.name.nil?
      self.name=self.name.strip
    end
  end
end
