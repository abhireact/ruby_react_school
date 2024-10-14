class MgMeetingDetail < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee)
  belongs_to(:mg_meeting_room)

  def self.myprm(start_date, end_date)
    @start = start_date
    @end = end_date
    puts(start_date)
    puts(end_date)
  end
  validates(:start_time, :end_time, { overlap: { scope: ["mg_meeting_room_id", "mg_school_id"], query_options: { active: nil, date_validation: nil, cancelled: nil } } })
  scope(:active, lambda {
    where({ is_deleted: false })
  })
  scope(:cancelled, lambda {
    where({ is_cancelled: false })
  })
  scope(:date_validation, lambda {
    where("(`mg_meeting_details`.`start_date` <= ? AND `mg_meeting_details`.`end_date` >= ?) OR (`mg_meeting_details`.`start_date` <= ? AND `mg_meeting_details`.`end_date` >= ?) OR (`mg_meeting_details`.`start_date` >= ? AND `mg_meeting_details`.`end_date` <= ?)", "#{@start}", "#{@start}", "#{@end}", "#{@end}", "#{@start}", "#{@end}")
  })
end
