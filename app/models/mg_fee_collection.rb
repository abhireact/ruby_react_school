class MgFeeCollection < ApplicationRecord
  belongs_to(:mg_fee_category)
  belongs_to(:mg_batch)
  belongs_to(:mg_fee_fine)
  belongs_to(:mg_school)
  has_many :mg_fee_collection_particulars,  dependent: :destroy 
  has_many :mg_students,  through: :mg_fee_collection_particulars, dependent: :destroy 
  has_many :mg_fee_collection_discounts,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_fee_collection_discounts)
  has_many :mg_finance_fees,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_finance_fees)

  def self.get_financial_year(mg_batch_id, mg_school_id, mg_time_table_id)
    this_month = Date.today.month
    financial_year_start = ""
    financial_year_end = ""
    academic_year = MgTimeTable.find_by({ id: mg_time_table_id, is_deleted: 0, mg_school_id: })
    if academic_year.present?
      financial_year_start = academic_year.start_date
    end
    if academic_year.present?
      financial_year_end = academic_year.end_date
    end
    fee_collections = self.where({ mg_batch_id:, is_deleted: 0, mg_school_id:, end_date: financial_year_start..financial_year_end })
    fee_collections
  end

  def self.get_financial_year_till_today(mg_batch_id, mg_school_id, mg_time_table_id)
    this_month = Date.today.month
    financial_year_start = ""
    academic_year = MgTimeTable.find_by({ id: mg_time_table_id, is_deleted: 0, mg_school_id: })
    if academic_year.present?
      financial_year_start = academic_year.start_date
    end
    financial_year_end = Date.today
    fee_collections = self.where({ mg_batch_id:, is_deleted: 0, mg_school_id:, end_date: financial_year_start..financial_year_end })
    fee_collections
  end
end
