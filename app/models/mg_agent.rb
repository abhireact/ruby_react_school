class MgAgent < ApplicationRecord
  validates(:agent_name, :status_of_agent, { presence: true, length: { maximum: 50 } })
  validates(:agent_name, { uniqueness: true })
  has_many :mg_master_datas,  dependent: :destroy 
end
