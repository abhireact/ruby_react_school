class MgTransportTimeManagement < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_transport)
  has_many :mg_guardian_transport_requisitions,  dependent: :destroy 

  def self.search(search)
    arr = Array.new
    arr.push(search)
    search_value = ""
    if search
      if arr.size > 0
        for i in 0..arr.size - 1 do
          search_value += " bus_stop_name LIKE '%#{arr.[](i)}%'"
          search_value += " or mg_transport_id IN (select id from mg_transports where route_name LIKE '%#{arr.[](i)}%') "
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
