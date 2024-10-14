class MgHobby < ApplicationRecord
  belongs_to(:mg_school)
  has_one :mg_hobby_associations,  dependent: :destroy 
  has_many :mg_users,  through: :mg_hobby_associations, dependent: :destroy 

  def self.search_by_hobby(search)
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
