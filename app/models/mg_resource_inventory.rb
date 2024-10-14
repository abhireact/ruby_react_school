class MgResourceInventory < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_subject)
  belongs_to(:mg_course)
  belongs_to(:mg_resource_category)
  belongs_to(:mg_resource_type)
  has_many :mg_books_transactions,  dependent: :destroy 
  before_save(:strip_whitespace)
  validates(:resource_number, { uniqueness: { scope: [:mg_school_id], conditions: lambda {
    where({ is_deleted: false })
  } } })

  def self.search(search)
    arr = Array.new
    arr.push(search)
    search_value = ""
    if search
      if arr.size > 0
        for i in 0..arr.size - 1 do
          search_value += "resource_number LIKE '%#{arr.[](i)}%' or status LIKE '%#{arr.[](i)}%' or name LIKE '%#{arr.[](i)}%' or author LIKE '%#{arr.[](i)}%'  or resource_number LIKE '%#{arr.[](i)}%'  "
          search_value += " or mg_resource_category_id IN (select id from mg_resource_categories where  name LIKE '%#{arr.[](i)}%') "
          search_value += " or mg_resource_type_id IN (select id from mg_resource_types where  name LIKE '%#{arr.[](i)}%') "
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

  def strip_whitespace
    unless self.name.nil?
      self.name=self.name.strip
    end
    unless self.author.nil?
      self.author=self.author.strip
    end
  end
end
