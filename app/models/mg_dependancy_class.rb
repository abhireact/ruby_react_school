class MgDependancyClass
  def self.dependancy_check(tableArray, column, id)
    @valuesOfDependancy = Array.new
    @presence = Array.new
    @table = ""
    tableArray.each { |table,|
      @presence = ActiveRecord::Base.connection.execute("select * from #{table} where #{column} = #{id} and is_deleted = 0")
      puts(@presence.inspect)
      @presence.to_a
      @presence.each({ as: :array }) { |row,|
        @valuesOfDependancy.push(row.[](0))
      }
      @table += "," + table
    }
    if @valuesOfDependancy.present?
      return true, @table
    else
      return false, @table
    end
  end

  def self.wing_dependancy(column, id)
    @wingArr = ["mg_allocate_rooms", "mg_alumni_get_togethers", "mg_alumni_programme_attendeds", "mg_class_timings", "mg_courses", "mg_disciplinary_actions", "mg_hostel_attendances", "mg_hostel_reallotment_requests", "mg_invitations", "mg_invite_get_togethers", "mg_payment_gateways", "mg_weekdays"]
    MgDependancyClass.dependancy_check(@wingArr, column, id)
  end

  def self.hostel_dependancy(column, id)
    @hostelArr = ["mg_allocate_rooms", "mg_complain_hostels", "mg_hostel_discipline_reports", "mg_hostel_floors", "mg_hostel_going_out_provisions", "mg_hostel_health_managements", "mg_hostel_programme_quota", "mg_hostel_reallotment_requests", "mg_hostel_room_types", "mg_hostel_rooms", "mg_hostel_rules", "mg_hostel_wardens", "mg_student_hostel_application_forms"]
    MgDependancyClass.dependancy_check(@hostelArr, column, id)
  end

  def self.hostels_dependancy(column, id)
    @hostelArr = ["mg_hostel_attendances"]
    MgDependancyClass.dependancy_check(@hostelArr, column, id)
  end

  def self.timetable_dependancy(column, id)
    @timeTableArr = ["mg_time_table_change_entries", "mg_time_table_entries"]
    MgDependancyClass.dependancy_check(@timeTableArr, column, id)
  end

  def self.holiday_dependancy(column, id)
    @holidayArry = ["mg_employee_holiday_attendances"]
    MgDependancyClass.dependancy_check(@holidayArry, column, id)
  end

  def self.studentCategory_dependancy(column, id)
    @categoryArray = ["mg_fee_collection_particulars", "mg_fee_fine_particulars", "mg_fee_particulars", "mg_student_admissions"]
    MgDependancyClass.dependancy_check(@categoryArray, column, id)
  end

  def self.caste_dependancy(column, id)
    @casteArray = ["mg_students"]
    MgDependancyClass.dependancy_check(@casteArray, column, id)
  end

  def self.casteCategory_dependancy(column, id)
    @casteArray = ["mg_students"]
    MgDependancyClass.dependancy_check(@casteArray, column, id)
  end

  def self.employeeDepartment_dependancy(column, id)
    @departmentArray = ["mg_account_central_incharges", "mg_albums", "mg_allergies", "mg_canteen_bill_details", "mg_canteen_wallet_amounts", "mg_check_up_schedule_records", "mg_employee_attendances", "mg_employee_holiday_attendances", "mg_employees", "mg_finance_officers", "mg_health_tests", "mg_hostel_wardens", "mg_inventory_store_managers", "mg_invitations", "mg_postal_records", "mg_sports_pay_deductions", "mg_user_albums"]
    MgDependancyClass.dependancy_check(@departmentArray, column, id)
  end

  def self.employeePosition_dependancy(column, id)
    @positionArray = ["mg_employees", "mg_fom_transport_bookings", "mg_guest_room_bookings", "mg_transports", "mg_vehicles"]
    MgDependancyClass.dependancy_check(@positionArray, column, id)
  end

  def self.homeWorkCategory_dependancy(column, id)
    @homeWorkArray = ["mg_assignments"]
    MgDependancyClass.dependancy_check(@homeWorkArray, column, id)
  end

  def self.fomCallerCategory_dependancy(column, id)
    @fomCallerArray = ["mg_query_records"]
    MgDependancyClass.dependancy_check(@fomCallerArray, column, id)
  end

  def self.callerCategory_dependancy(column, id)
    @fomCallerArray = ["mg_query_records"]
    MgDependancyClass.dependancy_check(@fomCallerArray, column, id)
  end

  def self.queryRecord_dependancy(column, id)
    @fomCallerArray = ["mg_query_records"]
    MgDependancyClass.dependancy_check(@fomCallerArray, column, id)
  end

  def self.specialisationHealthCare_dependancy(column, id)
    @spcArray = ["mg_users"]
    MgDependancyClass.dependancy_check(@spcArray, column, id)
  end

  def self.examType_dependancy(column, id)
    @examTypeArray = ["mg_cbsc_disciplines", "mg_cbsc_exam_components", "mg_cbsc_exam_schedules", "mg_cbsc_final_co_scholastic_grades", "mg_cbsc_other_marks_entries", "mg_cbsc_scholastic_marks_entries", "mg_final_scholastic_scores"]
    MgDependancyClass.dependancy_check(@examTypeArray, column, id)
  end

  def self.course_dependancy(column, id)
    @courseArray = ["mg_batch_groups", "mg_book_purchase_details", "mg_books_inventories", "mg_cbsc_exam_schedules", "mg_cbsc_exam_type_associations", "mg_cce_weightages_courses", "mg_class_designations", "mg_course_observation_groups", "mg_entrance_exam_details", "mg_item_consumptions", "mg_ranking_levels", "mg_resource_informations", "mg_resource_inventories", "mg_siblings", "mg_student_admissions", "mg_student_hostel_application_forms", "mg_student_item_consumptions", "mg_students", "mg_subjects"]
    MgDependancyClass.dependancy_check(@courseArray, column, id)
  end

  def self.batches_dependancy(column, id)
    @batchArray = ["mg_albums", "mg_allergies", "mg_assessment_scores", "mg_assignments", "mg_attendances", "mg_batch_contents", "mg_batch_documents", "mg_batch_subjects", "mg_batch_syllabuses", "mg_booster_dose_details", "mg_canteen_bill_details", "mg_canteen_wallet_amounts", "mg_cbsc_co_scholastic_grades", "mg_cbsc_exam_schedules", "mg_cbsc_exam_type_associations", "mg_cbsc_final_co_scholastic_grades", "mg_cbsc_other_marks_entries", "mg_cbsc_scholastic_marks_entries", "mg_cce_reports", "mg_check_up_schedule_records", "mg_class_timings", "mg_disciplinary_action_students", "mg_document_managements", "mg_exam_groups", "mg_exams", "mg_fee_category_batches", "mg_fee_collections", "mg_fee_discounts", "mg_fee_fine_particulars", "mg_fee_particulars", "mg_final_scholastic_scores", "mg_grading_levels", "mg_grouped_batches", "mg_grouped_exam_reports", "mg_grouped_exams", "mg_health_tests", "mg_inventory_issued_item_consumptions", "mg_invitations", "mg_item_consumptions", "mg_my_questions", "mg_postal_records", "mg_siblings", "mg_student_admissions", "mg_student_attendances", "mg_student_hostel_application_forms", "mg_student_item_consumptions", "mg_students", "mg_syllabus_trackers", "mg_time_table_change_entries", "mg_time_table_entries", "mg_user_albums", "mg_vaccination_details", "mg_weekdays"]
    MgDependancyClass.dependancy_check(@batchArray, column, id)
  end

  def self.students_dependancy(column, id)
    @studentsArray = ["mg_assessment_scores", "mg_assignment_documentations", "mg_assignment_submissions", "mg_attendances", "mg_books_transactions", "mg_booster_dose_details", "mg_canteen_bill_details", "mg_canteen_wallet_amounts", "mg_cbsc_final_co_scholastic_grades", "mg_cbsc_other_marks_entries", "mg_cbsc_scholastic_marks_entries", "mg_cce_reports", "mg_committee_members", "mg_complain_hostels", "mg_disciplinary_action_students", "mg_disciplinary_actions", "mg_exam_scores", "mg_fee_collection_particulars", "mg_fee_fine_particulars", "mg_final_scholastic_scores", "mg_finance_transaction_details", "mg_finance_transactions", "mg_grouped_exam_reports", "mg_health_tests", "mg_hostel_attendances", "mg_hostel_discipline_report_lists", "mg_hostel_going_out_provisions", "mg_hostel_health_managements", "mg_hostel_reallotment_requests", "mg_inventory_issued_item_consumptions", "mg_inventory_item_consumptions", "mg_inventory_item_damageds", "mg_inventory_item_returns", "mg_item_consumptions", "mg_placement_student_details", "mg_sport_team_students", "mg_sports_fine_students", "mg_sports_fines", "mg_sports_item_consumptions", "mg_student_hostel_application_forms", "mg_student_item_consumptions", "mg_vaccination_details"]
    MgDependancyClass.dependancy_check(@studentsArray, column, id)
  end

  def self.employee_dependancy(column, id)
    @employeesArray = ["mg_account_central_incharges", "mg_accounts", "mg_allergies", "mg_assignment_documentations", "mg_assignments", "mg_batch_contents", "mg_batch_documents", "mg_batches", "mg_books_transactions", "mg_canteen_bill_details", "mg_canteen_wallet_amounts", "mg_committee_members", "mg_employee_biometric_attendances", "mg_employee_subjects", "mg_finance_officers", "mg_guest_room_bookings", "mg_hostel_wardens", "mg_inventory_issued_item_consumptions", "mg_inventory_item_consumptions", "mg_inventory_item_damageds", "mg_inventory_item_returns", "mg_inventory_projections", "mg_inventory_proposals", "mg_inventory_store_managers", "mg_library_employees", "mg_sport_employee_data_results", "mg_sport_team_employees", "mg_sports_item_consumptions", "mg_sports_pay_deductiion_lists", "mg_sports_pay_deductions", "mg_syllabus_trackers", "mg_time_table_change_entries", "mg_time_table_entries", "mg_transports", "mg_vehicles"]
    MgDependancyClass.dependancy_check(@employeesArray, column, id)
  end

  def self.subject_dependancy(column, id)
    @subjectsArray = ["mg_assignments", "mg_cbsc_exam_schedules", "mg_cbsc_scholastic_marks_entries", "mg_curriculums", "mg_employee_subjects", "mg_exams", "mg_fa_groups_subjects", "mg_final_scholastic_scores", "mg_grouped_exam_reports", "mg_laboratory_incharges", "mg_resource_informations", "mg_resource_inventories", "mg_student_attandances", "mg_syllabuses", "mg_time_table_change_entries", "mg_time_table_entries"]
    MgDependancyClass.dependancy_check(@subjectsArray, column, id)
  end

  def self.empLeaveType_dependancy(column, id)
    @leaveTypeArray = ["mg_employee_attendances"]
    MgDependancyClass.dependancy_check(@leaveTypeArray, column, id)
  end

  def self.gameType_dependancy(column, id)
    @gameTypeArray = ["mg_sport_schedules", "mg_sport_teams", "mg_sports_results"]
    MgDependancyClass.dependancy_check(@gameTypeArray, column, id)
  end

  def self.scholasticExamsType_dependancy(column, id)
    @scholasticExamsArray = ["mg_cbsc_exam_schedules", "mg_cbsc_scholastic_marks_entries", "mg_final_scholastic_scores"]
    MgDependancyClass.dependancy_check(@scholasticExamsArray, column, id)
  end

  def self.coScholasticExamsType_dependancy(column, id)
    @coscholasticExamsArray = ["mg_cbsc_final_co_scholastic_grades", "mg_cbsc_other_marks_entries"]
    MgDependancyClass.dependancy_check(@coscholasticExamsArray, column, id)
  end

  def self.gradeScholasticExamsType_dependancy(column, id)
    @gradescholasticExamsArray = ["mg_exam_scores", "mg_exams"]
    MgDependancyClass.dependancy_check(@gradescholasticExamsArray, column, id)
  end

  def self.gradeCoScholasticExamsType_dependancy(column, id)
    @gradecoscholasticExamsArray = ["mg_cbsc_final_co_scholastic_grades", "mg_cbsc_other_marks_entries"]
    MgDependancyClass.dependancy_check(@gradecoscholasticExamsArray, column, id)
  end

  def self.vehicle_dependancy(column, id)
    @vehicle = ["mg_add_reports", "mg_guardian_transport_requisitions", "mg_transports"]
    MgDependancyClass.dependancy_check(@vehicle, column, id)
  end

  def self.report_dependancy(column, id)
    @report = ["mg_add_reports"]
    MgDependancyClass.dependancy_check(@report, column, id)
  end

  def self.payment_dependancy(column, id)
    @payment = ["mg_add_reports"]
    MgDependancyClass.dependancy_check(@payment, column, id)
  end

  def self.guardian_transport_request_dependancy(column, id)
    @guard_req = ["mg_guardian_transport_requisitions"]
    MgDependancyClass.dependancy_check(@guard_req, column, id)
  end

  def self.resource_category_dependancy(column, id)
    @resource_category = ["mg_resource_informations", "mg_resource_inventories", "mg_resource_types"]
    MgDependancyClass.dependancy_check(@resource_category, column, id)
  end

  def self.resource_type_dependancy(column, id)
    @resource_type = ["mg_resource_informations", "mg_resource_inventories"]
    MgDependancyClass.dependancy_check(@resource_type, column, id)
  end

  def self.resource_subject_dependancy(column, id)
    @resource_subject = ["mg_resource_informations", "mg_resource_inventories"]
    MgDependancyClass.dependancy_check(@resource_subject, column, id)
  end

  def self.inventory_item_category_dependancy(column, id)
    @item_category = ["mg_inventory_items", "mg_inventory_managements", "mg_item_consumptions", "mg_item_informations"]
    MgDependancyClass.dependancy_check(@item_category, column, id)
  end

  def self.inventory_item_dependancy(column, id)
    @item = ["mg_inventory_projection_items", "mg_inventory_proposal_items", "mg_inventory_vendor_items", "mg_item_consumptions", "mg_student_item_consumptions"]
    MgDependancyClass.dependancy_check(@item, column, id)
  end

  def self.inventory_store_dependancy(column, id)
    @store = ["inventory_stack_managements", "mg_inventory_room_managements", "mg_inventory_store_managers"]
    MgDependancyClass.dependancy_check(@store, column, id)
  end

  def self.inventory_room_dependancy(column, id)
    @room = ["inventory_stack_managements"]
    MgDependancyClass.dependancy_check(@room, column, id)
  end

  def self.faq_category_dependancy(column, id)
    @category = ["mg_faq_sub_categories", "mg_faqs"]
    MgDependancyClass.dependancy_check(@category, column, id)
  end

  def self.faq_sub_category_dependancy(column, id)
    @sub_category = ["mg_faqs"]
    MgDependancyClass.dependancy_check(@sub_category, column, id)
  end

  def self.student_admission_entrance_exam_venue_dependancy(column, id)
    @venue = ["mg_entrance_exam_details"]
    MgDependancyClass.dependancy_check(@venue, column, id)
  end

  def self.event_event_type_dependancy(column, id)
    @event_type = ["mg_events"]
    MgDependancyClass.dependancy_check(@event_type, column, id)
  end

  def self.event_event_committee_dependancy(column, id)
    @event_committee = ["mg_committee_members", "mg_events", "mg_sports_results"]
    MgDependancyClass.dependancy_check(@event_committee, column, id)
  end

  def self.fee_fee_category_dependancy(column, id)
    @fee_category = ["mg_fee_collections", "mg_fee_discounts", "mg_library_settings", "mg_particular_types"]
    MgDependancyClass.dependancy_check(@fee_category, column, id)
  end

  def self.fee_fee_collection_dependancy(column, id)
    @fee_collection = ["mg_fee_collections"]
    MgDependancyClass.dependancy_check(@fee_collection, column, id)
  end

  def self.curriculum_unit_dependancy(column, id)
    @unit = ["mg_syllabus_trackers", "mg_topics"]
    MgDependancyClass.dependancy_check(@unit, column, id)
  end

  def self.curriculum_syllabus_dependancy(column, id)
    @syllabus = ["mg_batch_syllabuses", "mg_syllabus_trackers", "mg_topics", "mg_units"]
    MgDependancyClass.dependancy_check(@syllabus, column, id)
  end

  def self.curriculum_topic_dependancy(column, id)
    @topic = ["mg_curriculums", "mg_syllabus_trackers"]
    MgDependancyClass.dependancy_check(@topic, column, id)
  end

  def self.laboratory_subjects_dependancy(column, id)
    @subject = ["mg_fee_fine_particulars", "mg_inventory_managements", "mg_item_consumptions", "mg_item_purchases", "mg_labs"]
    MgDependancyClass.dependancy_check(@subject, column, id)
  end

  def self.laboratory_item_dependancy(column, id)
    @item = ["mg_lab_inventories"]
    MgDependancyClass.dependancy_check(@item, column, id)
  end

  def self.laboratory_item_category_dependancy(column, id)
    @item_category = ["mg_inventory_items", "mg_inventory_managements", "mg_item_consumptions", "mg_item_informations"]
    MgDependancyClass.dependancy_check(@item_category, column, id)
  end

  def self.transport_route_dependency(column, id)
    @transport = ["mg_guardian_transport_requisitions", "mg_transport_time_managements", "mg_vehicles"]
    MgDependancyClass.dependancy_check(@transport, column, id)
  end

  def self.library_purchase_dependancy(column, id)
    @library = ["mg_resource_informations"]
    MgDependancyClass.dependancy_check(@library, column, id)
  end

  def self.student_hobby_dependancy(column, id)
    @hobby = ["mg_hobby_associations"]
    MgDependancyClass.dependancy_check(@hobby, column, id)
  end

  def self.student_sports_dependancy(column, id)
    @sports = ["mg_sports_associations"]
    MgDependancyClass.dependancy_check(@sports, column, id)
  end

  def self.student_extra_curricular_dependancy(column, id)
    @sports = ["mg_extra_curricular_associations"]
    MgDependancyClass.dependancy_check(@sports, column, id)
  end

  def self.salary_component_dependancy(column, id)
    @salary = ["mg_employee_grade_components", "mg_employee_payslip_components", "mg_grade_components"]
    MgDependancyClass.dependancy_check(@salary, column, id)
  end

  def self.emp_grade_dependancy(column, id)
    @emp_grade = ["mg_employees", "mg_grade_components"]
    MgDependancyClass.dependancy_check(@emp_grade, column, id)
  end
end
