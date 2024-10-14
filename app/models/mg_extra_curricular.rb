class MgExtraCurricular < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_extra_curricular_associations,  dependent: :destroy 

  def self.search_by_extra_curricular(search)
    arr = []
    arr.push(search)
    search_value = ""
    if search
      if arr.size > 0
        for i in 0..arr.size - 1 do
          search_value += " name LIKE '%#{arr.[](i)}%'"
          if i < arr.size.-(1)
            search_value += " or "
          end
        end
      end
      where(search_value)
    else
      all
    end
  end
end
