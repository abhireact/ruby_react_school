class MgEmployeeLeaveApplication < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee_leave_type)
  belongs_to(:mg_employee)
  has_many :mg_employee_attendances,  dependent: :destroy 

  def self.search_by_name(search)
    arr = []
    arr.push(search)
    search_value = ""
    if search
      if arr.size > 0
        for i in 0..arr.size - 1 do
          search_value += " mg_employee_id IN (select id from mg_employees where first_name LIKE '%#{arr.[](i)}%') "
          if i < arr.size.-(1)
          end
        end
      end
      where(search_value)
    else
      all
    end
  end

  def self.search_by_leave_type(search)
    arr = []
    arr.push(search)
    search_value = ""
    if search
      if arr.size > 0
        for i in 0..arr.size - 1 do
          search_value += " mg_employee_leave_type_id IN (select id from mg_employee_leave_types where leave_name LIKE '%#{arr.[](i)}%') "
          if i < arr.size.-(1)
          end
        end
      end
      where(search_value)
    else
      all
    end
  end

  def self.search_by_status(search)
    arr = []
    arr.push(search)
    search_value = ""
    if search
      if arr.size > 0
        for i in 0..arr.size - 1 do
          search_value += "select id from mg_employee_leave_applications where status LIKE '%#{arr.[](i)}%' "
          if i < arr.size.-(1)
          end
        end
      end
      where(search_value)
    else
      all
    end
  end
end
