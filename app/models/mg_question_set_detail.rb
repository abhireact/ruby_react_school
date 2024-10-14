class MgQuestionSetDetail < ApplicationRecord
  belongs_to(:mg_question_set)
  belongs_to(:mg_question_bank)
  belongs_to(:mg_school)

  def self.getQuestionData(set_id, school)
    question_id = MgQuestionSetDetail.where({ mg_question_set_id: set_id, is_deleted: 0, mg_school_id: school }).pluck(:mg_question_bank_id)
    question_data = MgQuestionBank.where({ mg_school_id: school, is_deleted: 0, id: question_id })
    option_data = MgQuestionDetail.where({ mg_school_id: school, is_deleted: 0, mg_question_bank_id: question_id })
    sub_question_data = MgSubQuestionBank.where({ mg_school_id: school, is_deleted: 0, mg_question_bank_id: question_id })
    sub_option_data = MgQuestionDetail.where({ mg_school_id: school, is_deleted: 0, mg_sub_question_bank_id: sub_question_data.pluck(:id) })
    question_arr = []
    question_data.each { |q,|
      question_detail_hash = {}
      question_detail_hash.[]=(:question_id, q.id)
      question_detail_hash.[]=(:mark, q.mark)
      question_detail_hash.[]=(:question_type, q.mg_question_type_id)
      if [4].include?(q.mg_question_type_id)
        assertion_reason = q.description.split("|-")
        asser_reas_hash = {}
        question_detail_hash.[]=(:asserstion, assertion_reason.[](0))
        question_detail_hash.[]=(:reason, assertion_reason.[](1))
        question_detail_hash.[]=(:main_question, assertion_reason)
      else
        question_detail_hash.[]=(:main_question, q.description)
      end
      if [1, 2, 4].include?(q.mg_question_type_id)
        @main_option_arr = []
        sub_question = ""
        get_option(q, option_data, sub_question)
        question_detail_hash.[]=(:options, @main_option_arr)
      else
        if [3, 5].include?(q.mg_question_type_id)
          @sub_question_bank_arr = []
          get_sub_question(q, sub_option_data, sub_question_data)
          question_detail_hash.[]=(:options, @sub_question_bank_arr)
        end
      end
      question_arr << question_detail_hash
    }
    question_arr
  end

  def self.get_option(question, option_data, sub_question)
    if [1, 2, 4].include?(question.mg_question_type_id)
      question_option = option_data.select { |op,|
        op.mg_question_bank_id == question.id
      }
    else
      question_option = sub_question.select { |op,|
        op.mg_sub_question_bank_id == option_data.id
      }
    end
    question_option.each { |options,|
      option_arr = []
      option_arr << options.name
      option_arr << options.id
      if [1, 2, 4].include?(question.mg_question_type_id)
        @main_option_arr << option_arr
      else
        @main_subquestion_option_arr << option_arr
      end
    }
    if [1, 2, 4].include?(question.mg_question_type_id)
      @main_option_arr
    else
      @main_subquestion_option_arr
    end
  end

  def self.get_sub_question(question, sub_option_data, sub_question_data)
    sub_question_banks = sub_question_data.select { |sub,|
      sub.mg_question_bank_id == question.id
    }
    sub_question_banks.each { |sub_question,|
      sub_question_detail_hash = {}
      sub_question_detail_hash.[]=(:sub_question, sub_question.question_name)
      sub_question_detail_hash.[]=(:sub_question_id, sub_question.id)
      sub_question_detail_hash.[]=(:assign_mark, sub_question.assign_mark)
      @main_subquestion_option_arr = []
      get_option(question, sub_question, sub_option_data)
      sub_question_detail_hash.[]=(:sub_option, @main_subquestion_option_arr)
      @sub_question_bank_arr << sub_question_detail_hash
    }
    @sub_question_bank_arr
  end
end
