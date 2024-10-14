class MgOnlineQuestionType < ApplicationRecord
  has_many :mg_question_banks,  dependent: :destroy 
end
