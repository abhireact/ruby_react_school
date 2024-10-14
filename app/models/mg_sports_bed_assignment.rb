class MgSportsBedAssignment < ApplicationRecord
  belongs_to(:mg_school)

  def self.myprm(admitted_date, discharge_date)
    @admitted_date = admitted_date
    @discharge_date = discharge_date
    puts(admitted_date)
    puts(discharge_date)
  end
  validates(:admitted_time, :discharge_time, { overlap: { scope: ["mg_sports_bed_details_id", "mg_school_id"], query_options: { active: nil, date_validation: nil } } })
  scope(:active, lambda {
    where({ is_deleted: false })
  })
  scope(:date_validation, lambda {
    where("(`mg_sports_bed_assignments`.`admitted_date` <= ? AND `mg_sports_bed_assignments`.`discharge_date` >= ?) OR (`mg_sports_bed_assignments`.`admitted_date` <= ? AND `mg_sports_bed_assignments`.`discharge_date` >= ?) OR (`mg_sports_bed_assignments`.`admitted_date` >= ? AND `mg_sports_bed_assignments`.`discharge_date` <= ?)", "#{@admitted_date}", "#{@admitted_date}", "#{@discharge_date}", "#{@discharge_date}", "#{@admitted_date}", "#{@discharge_date}")
  })
end
