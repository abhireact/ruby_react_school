class MgReportFrontPageSetting < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_wing)
  validates(:mg_wing_id, { uniqueness: { scope: [:mg_school_id, :report_parameter], conditions: lambda {
    where({ is_deleted: false })
  }, on: :create } })

  def self.get_front_page_setting_by_id(id)
    MgReportFrontPageSetting.find(id)
  end

  def self.get_all_front_page_data(school_id)
    MgReportFrontPageSetting.where({ is_deleted: 0, mg_school_id: school_id }).group_by(&:mg_wing_id)
  end

  def self.get_all_front_page_data_for_wing(wing_id)
    MgReportFrontPageSetting.where({ is_deleted: 0, mg_wing_id: wing_id })
  end

  def self.get_single_row_using_all_params(wing_id, report_parameter)
    MgReportFrontPageSetting.find_by({ is_deleted: 0, mg_wing_id: wing_id, report_parameter: })
  end
end
