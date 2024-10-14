class MgBatchGroup < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_course)
  has_many :mg_grouped_batches,  dependent: :destroy 
  has_many :mg_batches,  through: :mg_grouped_batches, dependent: :destroy 

  def has_active_batches
    self.mg_batches.each { |b,|
      if (b.is_deleted=0)
        return true
      end
    }
    false
  end
end
