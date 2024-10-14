class MgLibraryStackManagement < ApplicationRecord
  belongs_to(:mg_school)
  before_save(:strip_whitespace)

  def strip_whitespace
    unless self.room_no.nil?
      self.room_no=self.room_no.strip
    end
  end
end
