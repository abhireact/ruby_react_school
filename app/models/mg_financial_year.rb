class MgFinancialYear < ApplicationRecord
  validates_presence_of(:name, { length: { maximum: 50 } })
  validates_presence_of(:start_date, :end_date)
  validates(:name, { uniqueness: { conditions: lambda {
    where({ is_deleted: false })
  } } })
  has_many :mg_master_datas,  dependent: :destroy 
end
