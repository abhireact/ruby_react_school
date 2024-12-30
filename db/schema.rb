# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_12_26_072741) do
  create_table "actions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.text "sms_activity", size: :long, collation: "utf8_general_ci"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_module_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
  end

  create_table "blacklisted_tokens", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "jti"
    t.integer "user_id"
    t.datetime "exp", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["jti"], name: "index_blacklisted_tokens_on_jti", unique: true
    t.index ["user_id"], name: "index_blacklisted_tokens_on_user_id"
  end

  create_table "ckeditor_assets", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.integer "assetable_id"
    t.string "assetable_type", limit: 30
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable"
    t.index ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type"
  end

  create_table "document_managements", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "document_type"
    t.string "access_type"
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at", precision: nil
    t.integer "mg_user_id"
    t.boolean "is_transfer_certificate_produced"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "email_configurations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email_gateway"
    t.string "email_address"
    t.string "outgoing_smtp"
    t.integer "server_port"
    t.string "username"
    t.string "password"
    t.boolean "active"
    t.boolean "use_ssl_tls"
    t.integer "mg_school_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fullcalendar_engine_event_series", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "frequency", default: 1
    t.string "period", default: "monthly"
    t.datetime "starttime", precision: nil
    t.datetime "endtime", precision: nil
    t.boolean "all_day", default: false
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "fullcalendar_engine_events", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "title"
    t.datetime "starttime", precision: nil
    t.datetime "endtime", precision: nil
    t.boolean "all_day", default: false
    t.text "description"
    t.integer "event_series_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["event_series_id"], name: "index_fullcalendar_engine_events_on_event_series_id"
  end

  create_table "gateway_responses", id: :integer, charset: "latin1", force: :cascade do |t|
    t.text "encData"
    t.text "decData"
    t.text "merchDetails"
    t.text "payDetails"
    t.text "payModeSpecificData"
    t.text "extras"
    t.text "custDetails"
    t.text "responseDetails"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "update_by"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "inventory_stack_managements", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "room_no"
    t.string "rack_no"
    t.string "prefix"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_inventory_store_management_id"
    t.integer "mg_inventory_room_management_id"
  end

  create_table "mg_account_central_incharges", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_employee_department_id"
    t.integer "mg_employee_id"
    t.integer "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.string "status"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_user_id"
  end

  create_table "mg_account_transactions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_to_account_id"
    t.integer "mg_from_account_id"
    t.date "current_date"
    t.string "for_module"
    t.integer "mg_particular_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "amount"
    t.string "amount_transfer_type"
    t.string "transaction_type"
    t.index ["mg_school_id", "mg_particular_id"], name: "mg_school_id"
    t.index ["mg_school_id"], name: "mg_school_id_2"
  end

  create_table "mg_accounts", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "mg_account_name"
    t.integer "mg_department_id"
    t.integer "mg_employee_id"
    t.text "description"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_user_id"
  end

  create_table "mg_action_requireds", id: :integer, charset: "latin1", force: :cascade do |t|
    t.text "action_required"
    t.text "description"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_actions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "action_name"
    t.string "description"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_add_fee_categories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_school_id"], name: "index_mg_add_fee_categories_on_mg_school_id"
  end

  create_table "mg_add_fee_collections", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "student_name"
    t.string "admission_number"
    t.string "academic_year"
    t.string "collected_at"
    t.datetime "payment_date", precision: nil
    t.integer "total_amount"
    t.integer "paid_amount"
    t.string "mode_of_payment"
    t.integer "receipt_number"
    t.datetime "date_of_issuing_certificate", precision: nil
    t.boolean "is_paid"
    t.string "remarks"
    t.boolean "is_certificate_issued"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "date_of_receipt_generation", precision: nil
    t.boolean "is_student_active"
    t.string "mg_add_fee_category_name"
    t.string "mg_add_fee_particular_name"
    t.string "course_name"
    t.string "batch_name"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_other_receivable_account_id"
    t.string "student_status"
    t.date "date_of_cheque"
    t.date "date_of_draft"
    t.string "cheque_number"
    t.string "draft_number"
    t.string "bankname_and_branch"
    t.string "online_transaction_no"
    t.string "cheque_status"
    t.index ["mg_school_id"], name: "index_mg_add_fee_collections_on_mg_school_id"
  end

  create_table "mg_add_fee_particulars", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.integer "amount"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_add_fee_category_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_add_fee_category_id"], name: "index_mg_add_fee_particulars_on_mg_add_fee_category_id"
  end

  create_table "mg_add_other_receivable_accounts", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_school_id"
    t.string "account_name"
    t.string "applicable_for"
    t.boolean "is_deleted"
    t.string "description"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "status"
  end

  create_table "mg_add_reports", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_vehicle_id"
    t.integer "mg_report_type_id"
    t.integer "entered_by"
    t.date "valid_from"
    t.date "valid_to"
    t.text "comments"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.string "vendor_name"
    t.float "amount"
    t.date "payment_date"
    t.integer "mg_payment_type_id"
    t.boolean "is_payment_made"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_address_book_foms", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "Address"
    t.string "contact_number"
    t.integer "mg_designation_fom_id"
    t.string "email_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "designation"
  end

  create_table "mg_addresses", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "address_line1"
    t.string "address_line2"
    t.string "address_type"
    t.string "street"
    t.string "landmark"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "pin_code"
    t.integer "country_code"
    t.integer "mg_user_id"
    t.boolean "notification"
    t.boolean "subscription"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_school_id"], name: "mg_school_id"
    t.index ["mg_user_id", "mg_school_id"], name: "mg_user_id"
  end

  create_table "mg_admission_documents", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_admission_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "p_student_file_name"
    t.string "p_student_content_type"
    t.integer "p_student_file_size"
    t.datetime "p_student_updated_at", precision: nil
    t.string "p_father_file_name"
    t.string "p_father_content_type"
    t.integer "p_father_file_size"
    t.datetime "p_father_updated_at", precision: nil
    t.string "p_mother_file_name"
    t.string "p_mother_content_type"
    t.integer "p_mother_file_size"
    t.datetime "p_mother_updated_at", precision: nil
    t.string "f_aadhar_file_name"
    t.string "f_aadhar_content_type"
    t.integer "f_aadhar_file_size"
    t.datetime "f_aadhar_updated_at", precision: nil
    t.string "m_aadhar_file_name"
    t.string "m_aadhar_content_type"
    t.integer "m_aadhar_file_size"
    t.datetime "m_aadhar_updated_at", precision: nil
    t.string "s_aadhar_file_name"
    t.string "s_aadhar_content_type"
    t.integer "s_aadhar_file_size"
    t.datetime "s_aadhar_updated_at", precision: nil
    t.string "dob_certi_file_name"
    t.string "dob_certi_content_type"
    t.integer "dob_certi_file_size"
    t.datetime "dob_certi_updated_at", precision: nil
    t.string "family_photo_file_name"
    t.string "family_photo_content_type"
    t.integer "family_photo_file_size"
    t.datetime "family_photo_updated_at", precision: nil
    t.index ["mg_school_id"], name: "index_mg_admission_documents_on_mg_school_id"
    t.index ["mg_student_admission_id"], name: "index_mg_admission_documents_on_mg_student_admission_id"
  end

  create_table "mg_admission_payment_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "school_code"
    t.text "json_data"
    t.string "transaction_status"
    t.string "txn_id"
    t.string "gateway_txn_id"
    t.string "payment_gateway"
    t.integer "mg_student_admission_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "cheque_number"
    t.date "date_of_cheque"
    t.string "mode_of_payment"
    t.string "collected_at"
    t.string "online_transaction_no"
    t.string "draft_number"
    t.string "date_of_draft"
    t.string "bankname_and_branch"
    t.index ["mg_school_id"], name: "index_mg_admission_payment_details_on_mg_school_id"
    t.index ["mg_student_admission_id"], name: "index_mg_admission_payment_details_on_mg_student_admission_id"
  end

  create_table "mg_admission_schedules", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_admission_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.date "schedule_date"
    t.string "schedule_time"
    t.string "reference_code"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "meeting_type"
    t.index ["mg_school_id"], name: "index_mg_admission_schedules_on_mg_school_id"
    t.index ["mg_student_admission_id"], name: "index_mg_admission_schedules_on_mg_student_admission_id"
  end

  create_table "mg_admission_setting_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_course_id"
    t.integer "maximum_form_per_day"
    t.integer "maximum_form"
    t.date "start_date"
    t.date "end_date"
    t.string "status"
    t.integer "mg_admission_setting_id"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "from_year"
    t.integer "to_year"
    t.integer "from_month"
    t.integer "to_month"
    t.integer "from_day"
    t.integer "to_day"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.float "amount"
  end

  create_table "mg_admission_settings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_time_table_id"
  end

  create_table "mg_admit_card_settings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_time_table_id"
    t.integer "mg_course_id"
    t.integer "mg_batch_id"
    t.integer "mg_subject_id"
    t.datetime "date", precision: nil
    t.boolean "is_applicable"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "start_time", precision: nil
    t.datetime "end_time", precision: nil
  end

  create_table "mg_agents", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "agent_name"
    t.string "status_of_agent"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_album_photos", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_album_id"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at", precision: nil
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_albums", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.integer "mg_event_id"
    t.text "description"
    t.integer "mg_employee_department_id"
    t.integer "mg_batch_id"
    t.boolean "accessable_to­_employees"
    t.boolean "accessable_to­_students"
    t.boolean "accessable_to­_guardians"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "accessable_teacher"
  end

  create_table "mg_allergies", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_batch_id"
    t.integer "mg_student_id"
    t.integer "mg_employee_department_id"
    t.integer "mg_employee_id"
    t.string "name"
    t.text "description"
    t.string "status"
    t.text "medication_detail"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "allergy_for"
    t.integer "mg_user_id"
  end

  create_table "mg_allocate_room_lists", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_allocate_room_id"
    t.integer "mg_student_id"
    t.string "admission_number"
    t.integer "mg_hostel_floor_id"
    t.integer "mg_hostel_room_type_id"
    t.integer "mg_hostel_room_id"
    t.boolean "is_allocated"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_allocate_rooms", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_hostel_details_id"
    t.integer "mg_wing_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_user_id"
  end

  create_table "mg_alumni_get_togethers", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "event_name"
    t.date "event_date"
    t.time "start_time"
    t.time "end_time"
    t.text "venue"
    t.string "status"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_wing_id"
    t.string "passout_year"
    t.integer "mg_employee_specialization_id"
    t.integer "mg_user_id"
  end

  create_table "mg_alumni_item_sale_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_inventory_item_id"
    t.float "price"
    t.integer "required_quantity"
    t.integer "mg_user_id"
    t.boolean "cart_status"
    t.string "status"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "order_number"
  end

  create_table "mg_alumni_job_posting_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "position"
    t.text "job_description"
    t.string "minimum_qualification"
    t.integer "minimum_experience_required"
    t.text "company"
    t.string "company_website"
    t.integer "relevant_experience"
    t.string "alumni_id"
    t.string "referral_code"
    t.string "functional_area"
    t.string "technical_skills"
    t.string "soft_skills"
    t.string "salary"
    t.date "interview_date"
    t.date "last_date_of_application"
    t.string "status"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_alumni_photo_galleries", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "mg_alumni_id"
    t.integer "mg_user_id"
    t.string "status"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_alumni_pollings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.text "question"
    t.text "description"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_alumni_programme_attendeds", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_wing_id"
    t.string "time_table_year"
    t.integer "mg_employee_specialization_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_alumni_id"
  end

  create_table "mg_alumnis", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "middle_name"
    t.date "date_of_birth"
    t.string "gender"
    t.bigint "phone_number"
    t.bigint "integer"
    t.bigint "mobile_number"
    t.string "email_id"
    t.text "current_location"
    t.text "current_address"
    t.string "current_profession"
    t.string "designation"
    t.string "current_organization"
    t.text "hobbies"
    t.string "user_name"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_school_id"
    t.integer "mg_user_id"
    t.string "status"
    t.boolean "is_name_sharable"
    t.boolean "is_email_id_sharable"
    t.boolean "is_mobile_no_sharable"
    t.string "admission_number"
    t.boolean "is_programme_searchable"
    t.boolean "is_passing_out_searchable"
    t.boolean "is_specialization_searchable"
    t.boolean "is_current_location_searchable"
    t.boolean "is_current_profession_searchable"
    t.boolean "is_current_designation_searchable"
    t.boolean "is_current_organization_searchabler"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "country_code"
    t.boolean "is_date_of_birth_searchable"
  end

  create_table "mg_app_faq_categories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_app_faq_qas", id: :integer, charset: "latin1", force: :cascade do |t|
    t.text "question"
    t.text "answer"
    t.integer "mg_app_faq_category_id"
    t.integer "mg_app_faq_sub_category_id"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_app_faq_sub_categories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "mg_app_faq_category_id"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_archive_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "from_year_id"
    t.integer "to_year_id"
    t.integer "inserted_data_count"
    t.integer "mg_model_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_archive_reasons", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "reason_name"
    t.integer "mg_school_id"
    t.string "user_type"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_archive_students", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "admission_number"
    t.string "nationality"
    t.text "extra_curricular"
    t.text "health_record"
    t.text "class_record"
    t.text "hobby"
    t.text "sport_activity"
    t.string "class_roll_number"
    t.date "admission_date"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.integer "mg_batch_id"
    t.integer "mg_course_id"
    t.date "date_of_birth"
    t.string "gender"
    t.string "blood_group"
    t.string "birth_place"
    t.integer "mg_nationality_id"
    t.string "language"
    t.string "religion"
    t.integer "mg_student_catagory_id"
    t.boolean "is_sms_enable"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at", precision: nil
    t.integer "mg_time_table_id"
    t.string "status_description"
    t.boolean "is_active"
    t.boolean "has_paid_fees"
    t.integer "mg_user_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_student_admission_id"
    t.string "adharnumber"
    t.integer "mg_caste_id"
    t.integer "mg_caste_category_id"
    t.boolean "is_archive"
    t.integer "mg_house_details_id"
    t.string "roll_number"
    t.date "archive_date"
    t.integer "mg_archive_reason_id"
    t.integer "mg_student_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_assessement_syllabuses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "mg_time_table_id"
    t.integer "mg_course_id"
    t.integer "mg_batch_id"
    t.integer "mg_subject_id"
    t.string "syllabus_name"
    t.string "description"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mg_assessement_topics", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "mg_assessment_syllabus_id"
    t.integer "mg_assessment_chapter_id"
    t.string "topic_name"
    t.text "description"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mg_assessment_scores", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_id"
    t.float "marks_obtained"
    t.integer "mg_exam_id"
    t.integer "mg_batch_id"
    t.integer "mg_descriptive_indicator_id"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_assign_set_to_students", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_question_set_id"
    t.integer "mg_student_id"
    t.integer "mg_school_id"
    t.datetime "exam_date", precision: nil
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "exam_end_date", precision: nil
    t.integer "mg_class_online_assessment_id"
    t.index ["mg_question_set_id"], name: "index_mg_assign_set_to_students_on_mg_question_set_id"
    t.index ["mg_school_id"], name: "index_mg_assign_set_to_students_on_mg_school_id"
    t.index ["mg_student_id"], name: "index_mg_assign_set_to_students_on_mg_student_id"
  end

  create_table "mg_assignment_documentations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_id"
    t.integer "mg_assignment_id"
    t.integer "mg_employee_id"
    t.string "user_type"
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at", precision: nil
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_assignment_submissions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_id"
    t.integer "mg_assignment_id"
    t.string "status"
    t.text "remarks"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_assignments", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_employee_id"
    t.integer "mg_subject_id"
    t.integer "mg_batch_id"
    t.string "title"
    t.text "detail", collation: "utf8_general_ci"
    t.date "due_date"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_homework_category_id"
    t.boolean "is_carring_marks"
    t.datetime "assigned_date", precision: nil
  end

  create_table "mg_attendance_finalize_times", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_time_table_id"
    t.integer "mg_batch_id"
    t.integer "mg_employee_id"
    t.datetime "finalize_time", precision: nil
    t.integer "mg_school_id"
    t.boolean "is_submit"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "is_present_sms"
    t.boolean "is_absent_sms"
    t.index ["mg_batch_id"], name: "index_mg_attendance_finalize_times_on_mg_batch_id"
    t.index ["mg_employee_id"], name: "index_mg_attendance_finalize_times_on_mg_employee_id"
    t.index ["mg_school_id"], name: "index_mg_attendance_finalize_times_on_mg_school_id"
    t.index ["mg_time_table_id"], name: "index_mg_attendance_finalize_times_on_mg_time_table_id"
  end

  create_table "mg_attendance_settings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_wing_id"
    t.integer "mg_school_id"
    t.integer "time_duration"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_school_id"], name: "index_mg_attendance_settings_on_mg_school_id"
    t.index ["mg_wing_id"], name: "index_mg_attendance_settings_on_mg_wing_id"
  end

  create_table "mg_attendances", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_id"
    t.integer "mg_period_table_entry_id"
    t.boolean "forenoon"
    t.boolean "afternoon"
    t.string "reason"
    t.date "attendance_date"
    t.integer "mg_batch_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_bank_account_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_employee_id"
    t.string "bank_name"
    t.text "branch_address"
    t.string "account_number"
    t.string "ifs_code"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "ac_holder_name"
    t.string "esi_number"
    t.string "una_number"
  end

  create_table "mg_bank_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "beneficiary"
    t.string "bank_name"
    t.string "account_number"
    t.string "ifsc_code"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_batch_contents", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_batch_id"
    t.integer "mg_my_question_id"
    t.integer "mg_employee_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_batch_documents", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_employee_id"
    t.integer "mg_batch_id"
    t.integer "mg_document_management_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_batch_groups", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_course_id"
    t.string "name"
    t.integer "mg_school_id"
    t.string "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_batch_subjects", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_batch_id"
    t.integer "mg_subject_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "is_extra_curricular"
    t.string "scoring_type"
    t.integer "mg_employee_id"
  end

  create_table "mg_batch_syllabuses", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_syllabus_id"
    t.integer "mg_batch_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_batch_id"], name: "index_mg_batch_syllabuses_on_mg_batch_id"
  end

  create_table "mg_batches", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.integer "mg_course_id"
    t.datetime "start_date", precision: nil
    t.datetime "end_date", precision: nil
    t.boolean "is_active"
    t.integer "mg_employee_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "second_mg_employee_id"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_bed_assignments", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_bed_details_id"
    t.date "admitted_date"
    t.time "admitted_time"
    t.date "discharge_date"
    t.time "discharge_time"
    t.string "user_id"
    t.string "status"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_doctor_id"
    t.text "comments"
    t.string "module_type"
  end

  create_table "mg_bed_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "bed_no"
    t.text "description"
    t.string "status"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "module_type"
  end

  create_table "mg_bonafied_certificates", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "s_title"
    t.string "student_name"
    t.string "g_title"
    t.string "guardian_name"
    t.string "course"
    t.string "year"
    t.string "s1_title"
    t.string "date_of_birth"
    t.string "date_of_issue"
    t.integer "mg_school_id"
    t.integer "mg_student_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "verb"
  end

  create_table "mg_book_purchase_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "book_name"
    t.string "author"
    t.string "publisher"
    t.float "cost"
    t.integer "no_of_copies"
    t.float "total"
    t.integer "mg_course_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_book_purchase_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_book_purchases", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "vendor_name"
    t.date "date_of_purchase"
    t.float "Amount_paid"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_books_categories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "category_name"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_books_inventories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "book_no"
    t.string "book_name"
    t.string "author"
    t.string "publisher"
    t.string "edition"
    t.float "cost"
    t.integer "mg_books_category_id"
    t.integer "mg_course_id"
    t.boolean "non_issuable"
    t.boolean "is_damaged"
    t.boolean "is_lost"
    t.string "status"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.string "issued_to"
    t.date "due_date"
    t.integer "reserved_by"
    t.date "reservation_due_date"
    t.integer "mg_books_transaction_id"
    t.date "issued_date"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_books_transactions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_id"
    t.date "start_date"
    t.date "end_date"
    t.integer "issued_by"
    t.integer "received_by"
    t.string "return_book_condition"
    t.integer "mg_books_inventory_id"
    t.string "status"
    t.date "due_date"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_resource_inventory_id"
    t.string "user_type"
    t.integer "mg_employee_id"
    t.boolean "is_there_a_delay"
    t.boolean "is_it_returned_as_was_taken"
    t.string "is_fine_applicable"
    t.integer "no_of_days_delayed"
    t.float "amount"
  end

  create_table "mg_booster_dose_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_booster_dose_id"
    t.integer "mg_student_id"
    t.integer "mg_batch_id"
    t.integer "mg_time_table_id"
    t.date "date"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "name"
    t.string "frequency"
    t.boolean "is_particular_student"
    t.date "due_date"
  end

  create_table "mg_booster_doses", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "frequency"
    t.text "description"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_caller_categories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_caller_category_foms", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_canteen_amount_transactions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.boolean "is_central"
    t.boolean "is_account"
    t.integer "amount"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_canteen_balance_amounts", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_canteen_bill_detail_id"
    t.integer "paid_amount"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_canteen_bill_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "user_type"
    t.integer "mg_student_id"
    t.string "student_admission_no"
    t.integer "mg_batch_id"
    t.integer "mg_employee_id"
    t.string "employee_no"
    t.integer "mg_employee_department_id"
    t.integer "total_amount"
    t.integer "paid_amount"
    t.integer "balance_amount"
    t.integer "mg_user_id"
    t.integer "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_canteen_bill_payments", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_canteen_bill_detail_id"
    t.integer "mg_food_item_id"
    t.integer "quantity"
    t.integer "amount"
    t.integer "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "unit_quantity"
  end

  create_table "mg_canteen_meals", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.integer "mg_day_id"
    t.integer "mg_meal_category_id"
    t.integer "mg_food_item_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_canteen_id"
  end

  create_table "mg_canteen_regular_menus", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_food_item_id"
    t.text "description"
    t.string "status"
    t.text "remark"
    t.integer "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_canteen_wallet_amounts", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "user_type"
    t.integer "mg_student_id"
    t.integer "mg_batch_id"
    t.integer "mg_employee_id"
    t.integer "mg_employee_department_id"
    t.integer "wallet_amount"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_canteens", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "status"
  end

  create_table "mg_caste_categories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
  end

  create_table "mg_castes", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
  end

  create_table "mg_cbsc_co_scho_particular_class_assocs", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "mg_co_scholastic_exam_particular_id"
    t.string "integer"
    t.string "mg_batch_id"
    t.string "mg_course_id"
    t.string "is_deleted"
    t.string "boolean"
    t.string "mg_school_id"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_cbsc_co_scholastic_exam_components", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_time_table_id"
    t.integer "index"
    t.integer "mg_cbsc_exam_type_id"
  end

  create_table "mg_cbsc_co_scholastic_exam_particulars", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_cbsc_co_scholastic_exam_component_id"
    t.string "name"
    t.string "description"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "scoring_type", default: "Grading"
    t.boolean "subject_access"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_cbsc_co_scholastic_grades", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_batch_id"
    t.string "name"
    t.string "description"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_time_table_id"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_cbsc_disciplines", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_cbsc_exam_type_id"
    t.integer "mg_cbsc_exam_particular_id"
    t.string "name"
    t.string "description"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_cbsc_exam_components", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_cbsc_exam_type_id"
    t.integer "mg_cbsc_exam_particular_id"
    t.string "name"
    t.integer "weightage"
    t.integer "Max_Marks"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_cbsc_exam_particulars", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "exam_type_id"
    t.string "name"
    t.string "description"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_cbsc_exam_schedules", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_batch_id"
    t.integer "mg_course_id"
    t.integer "mg_subject_id"
    t.integer "mg_cbsc_exam_type_id"
    t.integer "mg_scholastic_exam_particular_id"
    t.integer "mg_scholastic_exam_component_id"
    t.datetime "start_date", precision: nil
    t.datetime "end_date", precision: nil
    t.time "start_time"
    t.time "end_time"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "date", precision: nil
    t.integer "subject_weightage"
    t.integer "subject_maxmarks"
    t.integer "mg_time_table_id"
    t.boolean "mark_disable"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_cbsc_exam_type_associations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_course_id"
    t.integer "mg_batch_id"
    t.integer "mg_cbsc_exam_type_id"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_cbsc_exam_types", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "exam_type_name"
    t.string "description"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "index"
    t.integer "mg_time_table_id"
  end

  create_table "mg_cbsc_final_co_scholastic_grades", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_id"
    t.integer "mg_cbsc_exam_type_id"
    t.integer "mg_cbsc_co_scholastic_exam_component_id"
    t.integer "mg_cbsc_co_scholastic_exam_particular_id"
    t.integer "mg_batch_id"
    t.integer "mg_cbsc_co_scholastic_grade_id"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "obtained_marks"
    t.text "grade_comment"
    t.index ["mg_school_id", "mg_batch_id", "mg_student_id"], name: "mg_school_id_3"
    t.index ["mg_school_id", "mg_batch_id"], name: "mg_school_id_2"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_cbsc_notebook_submissions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_cbsc_exam_id"
    t.integer "mg_cbsc_exam_perticular_id"
    t.string "notebook_submission_component"
    t.text "description"
    t.integer "weightage"
    t.integer "max_marks"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_cbsc_other_marks_entries", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_id"
    t.integer "mg_cbsc_exam_type_id"
    t.integer "mg_cbsc_co_scholastic_exam_component_id"
    t.integer "mg_cbsc_co_scholastic_exam_particular_id"
    t.integer "mg_batch_id"
    t.integer "mg_cbsc_co_scholastic_grade_id"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "obtained_marks"
    t.text "grade_comment"
    t.index ["mg_school_id", "mg_batch_id"], name: "mg_school_id_2"
    t.index ["mg_school_id", "mg_student_id"], name: "mg_school_id_3"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_cbsc_scho_particular_class_assocs", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_scholastic_exam_particular_id"
    t.integer "mg_batch_id"
    t.integer "mg_course_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_cbsc_scholastic_marks_entries", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_batch_id"
    t.integer "mg_subject_id"
    t.integer "mg_cbsc_exam_type_id"
    t.integer "mg_scholastic_exam_particular_id"
    t.integer "mg_scholastic_exam_component_id"
    t.float "max_marks"
    t.float "obtained_marks"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_student_id"
    t.boolean "is_absent"
    t.boolean "is_accepted"
    t.string "grade"
    t.boolean "is_applicable"
    t.integer "mg_subject_component_id"
    t.string "absent_reason"
    t.index ["mg_school_id", "mg_batch_id"], name: "mg_school_id_2"
    t.index ["mg_school_id", "mg_subject_id"], name: "mg_cbsc_scholastic_marks_index1"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_cbsc_subject_enrichment_activity_components", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_cbsc_exam_id"
    t.integer "mg_cbsc_exam_perticular_id"
    t.integer "mg_cbsc_subject_enrichment_id"
    t.string "cbsc_subject_enrichment_component"
    t.text "description"
    t.integer "weightage"
    t.integer "max_marks"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_cbsc_subject_enrichments", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_cce_exam_categories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "updated_by"
    t.integer "created_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_cce_grades", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.float "grade_point"
    t.integer "mg_cce_grades_set_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_cce_grades_sets", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_cce_reports", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_id"
    t.integer "mg_batch_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "is_deleted"
  end

  create_table "mg_cce_weightages", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "weightages"
    t.string "criteria_type"
    t.integer "mg_cce_exam_category_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_cce_weightages_courses", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_cce_weightages_id"
    t.integer "mg_course_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_central_account_transactions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_to_account_id"
    t.integer "mg_from_account_id"
    t.date "current_date"
    t.string "for_module"
    t.integer "mg_particular_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "amount"
    t.string "transaction_type"
    t.string "amount_transfer_type"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "purpose"
    t.string "status"
    t.text "Reason"
    t.index ["mg_school_id", "mg_particular_id"], name: "mg_school_id"
  end

  create_table "mg_certificate_trackings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_id"
    t.date "date_of_issue"
    t.integer "mg_school_id"
    t.integer "issued_times"
    t.string "certificate_type"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_employee_id"
  end

  create_table "mg_chapters", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "mg_batch_id"
    t.integer "mg_assessment_syllabus_id"
    t.string "chapter_name"
    t.date "start_date"
    t.date "end_date"
    t.string "description"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mg_character_certficates", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "s_title"
    t.string "student_name"
    t.string "g1_title"
    t.string "gurdian_name"
    t.string "course"
    t.string "year"
    t.string "s1_title"
    t.string "s2_title"
    t.string "s3_title"
    t.string "s4_title"
    t.string "s5_title"
    t.string "date_of_birth"
    t.integer "mg_student_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "birth_date"
    t.string "cond"
    t.string "passed"
    t.string "division"
    t.string "course_from"
    t.string "course_to"
  end

  create_table "mg_check_up_schedule_records", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_check_up_schedule_id"
    t.integer "mg_employee_department_id"
    t.integer "mg_batch_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_check_up_type_id"
  end

  create_table "mg_check_up_schedules", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "doctor_name"
    t.integer "mg_check_up_type_id"
    t.date "date"
    t.time "start_time"
    t.time "end_time"
    t.string "checkup_for"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_doctor_id"
  end

  create_table "mg_checkup_particulars", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "particulars"
    t.string "applicable"
    t.boolean "show_in_healthcard"
    t.string "mg_checkup_type_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "normal"
  end

  create_table "mg_checkup_types", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_class_designations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.float "marks"
    t.integer "mg_course_id"
    t.float "cgpa"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_class_online_assessment_users", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_id"
    t.integer "mg_class_online_assessment_id"
    t.integer "mg_batch_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_user_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_class_online_assessments", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_time_table_id"
    t.integer "mg_course_id"
    t.integer "mg_batch_id"
    t.integer "mg_subject_id"
    t.integer "mg_create_question_paper_id"
    t.integer "mg_online_platform_id"
    t.datetime "start_time", precision: nil
    t.datetime "end_time", precision: nil
    t.text "mg_online_class_details_1"
    t.text "mg_online_id_password_1"
    t.datetime "mg_online_meeting_start_1", precision: nil
    t.datetime "mg_online_meeting_end_1", precision: nil
    t.integer "mg_online_meeting_duration_1"
    t.text "mg_online_class_details_2"
    t.text "mg_online_id_password_2"
    t.datetime "mg_online_meeting_start_2", precision: nil
    t.datetime "mg_online_meeting_end_2", precision: nil
    t.integer "mg_online_meeting_duration_2"
    t.text "mg_online_class_details_3"
    t.text "mg_online_id_password_3"
    t.datetime "mg_online_meeting_start_3", precision: nil
    t.datetime "mg_online_meeting_end_3", precision: nil
    t.integer "mg_online_meeting_duration_3"
    t.text "mg_online_class_details_4"
    t.text "mg_online_id_password_4"
    t.datetime "mg_online_meeting_start_4", precision: nil
    t.datetime "mg_online_meeting_end_4", precision: nil
    t.integer "mg_online_meeting_duration_4"
    t.text "mg_online_class_details_5"
    t.text "mg_online_id_password_5"
    t.datetime "mg_online_meeting_start_5", precision: nil
    t.datetime "mg_online_meeting_end_5", precision: nil
    t.integer "mg_online_meeting_duration_5"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_user_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_class_online_attendances", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_time_table_id"
    t.integer "mg_course_id"
    t.integer "mg_batch_id"
    t.integer "mg_subject_id"
    t.integer "mg_student_id"
    t.datetime "exam_start_time", precision: nil
    t.string "session_id"
    t.integer "mg_create_question_paper_id"
    t.integer "mg_set_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_class_section_changes", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_school_id"
    t.integer "mg_student_id"
    t.integer "from_class_id"
    t.integer "to_class_id"
    t.integer "from_section_id"
    t.integer "to_section_id"
    t.integer "from_academic_year"
    t.integer "to_academic_year"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "from_demotion_id"
    t.integer "to_demotion_id"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_class_timings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_batch_id"
    t.integer "mg_weekday_id"
    t.integer "mg_wing_id"
    t.string "name"
    t.time "start_time"
    t.time "end_time"
    t.boolean "is_break"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_comments", id: :integer, charset: "latin1", force: :cascade do |t|
    t.text "body"
    t.integer "commentable_id"
    t.string "commentable_type"
    t.integer "mg_user_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "is_answered"
    t.index ["commentable_id", "commentable_type"], name: "index_mg_comments_on_commentable_id_and_commentable_type"
  end

  create_table "mg_committee_members", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_event_committee_id"
    t.integer "mg_employee_id"
    t.integer "mg_student_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_common_custom_fields", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "model_name"
    t.string "name"
    t.string "text_data"
    t.string "data_type"
    t.string "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_company_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "address_line1"
    t.string "address_line2"
    t.string "city"
    t.string "pin_code"
    t.string "state"
    t.string "country"
    t.string "phone_number"
    t.string "gst"
    t.string "pan"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.string "status"
    t.string "code"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_complain_hostels", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_hostel_details_id"
    t.string "room_no"
    t.text "reason"
    t.string "programme"
    t.date "date"
    t.string "status"
    t.integer "mg_student_id"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_consolidated_subjects", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_time_table_id"
    t.integer "mg_course_id"
    t.integer "mg_batch_id"
    t.integer "mg_subject_id"
    t.string "subject_name"
    t.string "weightage"
    t.boolean "consolidated"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_course_observation_groups", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_observation_group_id"
    t.integer "mg_course_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_courses", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "course_name"
    t.string "code"
    t.string "section_name"
    t.string "grading_type"
    t.integer "mg_wing_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_time_table_id"
    t.integer "index"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_create_question_papers", id: :integer, charset: "latin1", force: :cascade do |t|
    t.text "name_of_test", collation: "utf8_general_ci"
    t.integer "mg_time_table_id"
    t.integer "mg_course_id"
    t.integer "mg_batch_id"
    t.integer "mg_subject_id"
    t.integer "total_question_required"
    t.integer "maximum_mark"
    t.datetime "exam_date", precision: nil
    t.integer "time_allotted"
    t.integer "sets_required"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "mg_instructions", collation: "utf8_general_ci"
    t.integer "mg_exam_type_id"
    t.integer "mg_exam_particular_id"
    t.integer "mg_exam_component_id"
    t.integer "mg_re_exam_type_id"
    t.boolean "is_rexam"
    t.date "from_paper_date"
    t.index ["mg_batch_id"], name: "index_mg_create_question_papers_on_mg_batch_id"
    t.index ["mg_course_id"], name: "index_mg_create_question_papers_on_mg_course_id"
    t.index ["mg_school_id"], name: "index_mg_create_question_papers_on_mg_school_id"
    t.index ["mg_subject_id"], name: "index_mg_create_question_papers_on_mg_subject_id"
    t.index ["mg_time_table_id"], name: "index_mg_create_question_papers_on_mg_time_table_id"
  end

  create_table "mg_curriculums", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_user_id"
    t.integer "mg_subject_id"
    t.integer "mg_topic_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_custom_fields_data", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "mg_user_id"
    t.string "mg_custom_field_id"
    t.string "value"
    t.string "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_dashboard_uploads", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_school_id"
    t.integer "mcsms_file_tracker_id"
    t.integer "from_user"
    t.string "file_name"
    t.integer "to_user"
    t.string "user_type"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_defaulter_trackers", id: :integer, charset: "latin1", force: :cascade do |t|
    t.date "defaulter_date"
    t.integer "mg_course_id"
    t.integer "mg_batch_id"
    t.integer "mg_student_id"
    t.float "paid_amount"
    t.float "remaining_amount"
    t.float "total_amount"
    t.string "account_name"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_descriptive_indicators", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "mg_fa_criteria_id"
    t.string "describable_type"
    t.integer "describable_id"
    t.integer "sort_order"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.float "total_marks"
  end

  create_table "mg_designation_foms", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_disciplinary_action_students", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_disciplinary_action_id"
    t.integer "mg_student_id"
    t.integer "mg_batch_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_disciplinary_actions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_wing_id"
    t.integer "mg_batches_id"
    t.integer "mg_student_id"
    t.text "remark"
    t.text "action_taken"
    t.string "status"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "subject"
  end

  create_table "mg_document_managements", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "file_file_name", collation: "utf8_general_ci"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at", precision: nil
    t.integer "mg_user_id"
    t.integer "mg_employee_folder_id"
    t.integer "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_add_report_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "document_type"
    t.string "access_type"
    t.integer "mg_batch_id"
    t.integer "mg_alumni_programme_attended_id"
    t.integer "mg_inventory_item_id"
    t.datetime "release_date", precision: nil
    t.string "upload_type"
    t.string "cloud_url"
    t.integer "original_file_id"
    t.index ["mg_school_id"], name: "mg_school_id"
    t.index ["mg_user_id", "mg_school_id"], name: "mg_user_id"
  end

  create_table "mg_document_trackers", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_user_id"
    t.integer "mg_document_management_id"
    t.integer "mg_school_id"
    t.integer "mg_count"
    t.datetime "download_date", precision: nil
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_document_uploads", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "file_name"
    t.datetime "date", precision: nil
    t.string "document_type"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_email_configurations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.text "address"
    t.integer "port"
    t.text "domain"
    t.text "user_name"
    t.text "password"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "hashed_password"
    t.string "salt"
  end

  create_table "mg_email_server_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.text "domain"
    t.integer "port"
    t.text "outgoing_server"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_emails", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "mg_email_id"
    t.string "email_type"
    t.boolean "notification"
    t.boolean "subscription"
    t.integer "mg_user_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_school_id"], name: "mg_school_id"
    t.index ["mg_user_id", "mg_school_id"], name: "mg_user_id"
  end

  create_table "mg_employee_attendances", id: :integer, charset: "latin1", force: :cascade do |t|
    t.date "absent_date"
    t.integer "mg_employee_id"
    t.integer "mg_leave_type_id"
    t.integer "is_approved"
    t.boolean "is_lock"
    t.string "reason"
    t.string "time"
    t.boolean "is_halfday"
    t.boolean "is_late_come"
    t.boolean "is_afternoon"
    t.boolean "abcent_without_notice"
    t.integer "mg_employee_department_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_employee_leave_application_id"
    t.index ["mg_school_id", "mg_employee_id"], name: "mg_school_id_2"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_employee_banks", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_school_id"
    t.integer "mg_employee_id"
    t.integer "mg_bank_detail_id"
    t.string "payment_mode"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_bank_detail_id"], name: "index_mg_employee_banks_on_mg_bank_detail_id"
    t.index ["mg_employee_id"], name: "index_mg_employee_banks_on_mg_employee_id"
    t.index ["mg_school_id"], name: "index_mg_employee_banks_on_mg_school_id"
  end

  create_table "mg_employee_biometric_attendances", id: :integer, charset: "latin1", force: :cascade do |t|
    t.date "date"
    t.time "check_in"
    t.time "check_out"
    t.integer "mg_employee_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_employee_categories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "category_name"
    t.string "prefix"
    t.string "suffix"
    t.boolean "status"
    t.string "position"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_employee_children", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_user_id"
    t.string "employee_name"
    t.string "employee_type"
    t.string "employee_id"
    t.date "joining_date"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_employee_departments", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "department_name"
    t.string "department_code"
    t.boolean "status"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_employee_excels", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "fields_name"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_employee_experience_certificates", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_employee_id"
    t.integer "mg_school_id"
    t.string "title"
    t.string "employee_name"
    t.string "guardian_title"
    t.string "guardian_name"
    t.string "cnic_number"
    t.string "subjects"
    t.string "designation"
    t.string "joining_date"
    t.string "last_working_date"
    t.string "title_sub"
    t.string "title_sub1"
    t.string "title_sub2"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_employee_folders", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "folder_name", collation: "utf8_unicode_ci"
    t.integer "mg_employee_id"
    t.integer "mg_employee_chaild_folder_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "folder_type"
    t.integer "mg_batch_id"
    t.string "mg_table_name"
    t.integer "mg_table_data_id"
    t.integer "mg_batch_subject_id"
  end

  create_table "mg_employee_grade_components", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_employee_id"
    t.integer "mg_salary_component_id"
    t.float "amount"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "is_edited"
  end

  create_table "mg_employee_grades", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "grade_name"
    t.string "priority"
    t.boolean "status"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_employee_holiday_attendances", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_holiday_id"
    t.integer "mg_employee_id"
    t.integer "mg_employee_department_id"
    t.boolean "is_present"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.date "day_of_presence"
  end

  create_table "mg_employee_leave_applications", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_employee_id"
    t.integer "mg_employee_leave_type_id"
    t.date "from_date"
    t.date "to_date"
    t.string "reject_reason"
    t.string "reason"
    t.string "status"
    t.boolean "is_halfday"
    t.boolean "is_afternoon"
    t.date "status_date"
    t.date "applied_date"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_employee_leave_types", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "leave_name"
    t.string "leave_code"
    t.float "max_leave_count"
    t.integer "reset_period"
    t.date "reset_date"
    t.boolean "is_auto_reset"
    t.boolean "is_carry_forward"
    t.boolean "status"
    t.string "carry_forward_limit"
    t.float "accumilation_count"
    t.string "accumilation_period"
    t.string "min_leave_count"
    t.integer "mg_employee_type_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "is_accumilation"
    t.integer "minimum_year_experience"
    t.integer "minimum_month_experience"
    t.string "gender"
    t.boolean "is_leave_should_not_be_deducted"
    t.string "marital_status"
    t.boolean "is_showable"
    t.boolean "delay_deduction"
    t.integer "delay_time"
    t.integer "delay_days"
    t.integer "leave_deduction_count"
    t.integer "monthly_limit"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_employee_leaves", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_employee_id"
    t.integer "mg_leave_type_id"
    t.float "leave_taken"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.float "available_leave"
    t.date "leave_month_year"
  end

  create_table "mg_employee_other_subjects", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_employee_id"
    t.integer "mg_co_scholastic_exam_particular_id"
    t.integer "mg_cbsc_co_scholastic_exam_component_id"
    t.integer "mg_batch_id"
    t.integer "mg_course_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_employee_pay_deductions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_employee_id"
    t.string "employee_number"
    t.integer "no_of_days"
    t.integer "month"
    t.integer "year"
    t.integer "mg_user_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_employee_payslip_components", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_employee_payslip_detail_id"
    t.integer "mg_salary_component_id"
    t.integer "mg_school_id"
    t.float "amount"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "reason"
  end

  create_table "mg_employee_payslip_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_employee_id"
    t.float "extra_leave_taken"
    t.integer "month"
    t.integer "year"
    t.string "is_approved"
    t.float "no_of_payable_days_in_the_month"
    t.float "leaves_taken_till_date_in_the_year"
    t.float "leave_balance"
    t.float "total_leave"
    t.float "total_Gross_salary"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.float "total_net_amount"
    t.float "over_time"
    t.boolean "is_released"
    t.boolean "is_editable"
    t.text "reason"
  end

  create_table "mg_employee_payslips", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_employee_id"
    t.decimal "payscale", precision: 8, scale: 2
    t.date "from_date"
    t.date "to_date"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_employee_positions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_employee_category_id"
    t.string "position_name"
    t.boolean "status"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_employee_subjects", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_employee_id"
    t.integer "mg_subject_id"
    t.integer "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_employee_types", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "employee_type"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_employee_weekdays", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "weekday"
    t.string "name"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_employees", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_nationality_id"
    t.integer "mg_employee_type_id"
    t.integer "mg_employee_category_id"
    t.integer "mg_employee_position_id"
    t.integer "mg_employee_department_id"
    t.integer "mg_reporting_manager_id"
    t.integer "mg_employee_grade_id"
    t.integer "mg_user_id"
    t.integer "mg_manager_id"
    t.boolean "is_referred"
    t.string "emergency_contact_name"
    t.string "emergency_contact_number"
    t.text "hobby"
    t.text "extra_curricular"
    t.text "sport_activity"
    t.string "language"
    t.string "nationality"
    t.string "employee_number"
    t.date "joining_date"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "gender"
    t.string "job_title"
    t.string "qualification"
    t.text "experience_detail"
    t.integer "experience_year"
    t.integer "experience_month"
    t.string "status"
    t.string "status_description"
    t.date "date_of_birth"
    t.string "marital_status"
    t.integer "children_count"
    t.string "father_name"
    t.string "mother_name"
    t.string "husband_name"
    t.string "blood_group"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.binary "photo_data"
    t.integer "photo_file_size"
    t.string "additional_detail"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "referred_by"
    t.string "designation"
    t.boolean "is_ltc_applicable"
    t.integer "max_no_of_class"
    t.decimal "pay_scale", precision: 8, scale: 2
    t.date "last_working_day"
    t.string "adharnumber"
    t.string "column_name"
    t.boolean "is_archive"
    t.integer "mg_archive_reason_id"
    t.date "archive_date"
    t.boolean "sms_access"
    t.boolean "other_mark_entry_access"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_entrance_exam_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_course_id"
    t.date "start_date"
    t.time "start_time"
    t.time "end_time"
    t.text "exam_venue"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_entrance_exam_venue_id"
  end

  create_table "mg_entrance_exam_venues", id: :integer, charset: "latin1", force: :cascade do |t|
    t.text "exam_venue"
    t.string "institute_name"
    t.integer "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_event_committees", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "committee_name"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_event_types", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "event_color"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_events", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "title"
    t.integer "mg_event_type_id"
    t.string "event_privacy"
    t.text "event_description"
    t.time "start_time"
    t.time "end_time"
    t.date "event_date"
    t.date "end_date"
    t.boolean "all_day"
    t.boolean "editable"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_event_committee_id"
  end

  create_table "mg_exam_attendances", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_school_id"
    t.integer "mg_time_table_id"
    t.integer "mg_batch_id"
    t.integer "mg_cbsc_exam_type_id"
    t.integer "mg_scholastic_exam_particular_id"
    t.date "start_date"
    t.date "end_date"
    t.string "meetings"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_batch_id"], name: "index_mg_exam_attendances_on_mg_batch_id"
    t.index ["mg_cbsc_exam_type_id"], name: "index_mg_exam_attendances_on_mg_cbsc_exam_type_id"
    t.index ["mg_scholastic_exam_particular_id"], name: "index_mg_exam_attendances_on_mg_scholastic_exam_particular_id"
    t.index ["mg_school_id"], name: "index_mg_exam_attendances_on_mg_school_id"
    t.index ["mg_time_table_id"], name: "index_mg_exam_attendances_on_mg_time_table_id"
  end

  create_table "mg_exam_groups", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.integer "mg_batch_id"
    t.string "exam_type"
    t.integer "is_published"
    t.integer "result_published"
    t.float "maximum_mark"
    t.float "minimum_mark"
    t.date "exam_date"
    t.integer "is_final_exam"
    t.integer "cce_exam_category_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_exam_scores", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_id"
    t.integer "mg_exam_id"
    t.integer "marks"
    t.integer "mg_grading_level_id"
    t.string "remarks"
    t.boolean "is_failed"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_exam_systems", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "grading_name"
    t.integer "grading_system"
    t.text "description"
    t.integer "is_enabled"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_examination_absent_reasons", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "is_applicable"
    t.index ["mg_school_id"], name: "index_mg_examination_absent_reasons_on_mg_school_id"
  end

  create_table "mg_examination_report_release_dates", id: :integer, charset: "latin1", force: :cascade do |t|
    t.date "release_date"
    t.boolean "is_released"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_time_table_id"
    t.integer "mg_batch_id"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "guardian_release_date", precision: nil
    t.datetime "school_reopen_date", precision: nil
    t.date "due_date"
    t.string "paid_fee_amount_percentage"
    t.datetime "employee_release_date", precision: nil
    t.index ["mg_batch_id"], name: "index_mg_examination_report_release_dates_on_mg_batch_id"
    t.index ["mg_school_id"], name: "index_mg_examination_report_release_dates_on_mg_school_id"
    t.index ["mg_time_table_id"], name: "index_mg_examination_report_release_dates_on_mg_time_table_id"
  end

  create_table "mg_exams", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_exam_group_id"
    t.integer "mg_subject_id"
    t.datetime "start_time", precision: nil
    t.datetime "end_time", precision: nil
    t.float "maximum_marks"
    t.float "minimum_marks"
    t.integer "mg_grading_level_id"
    t.integer "weightage"
    t.integer "mg_event_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.date "start_date_data"
    t.time "start_time_data"
    t.time "end_time_data"
    t.integer "mg_batch_id"
  end

  create_table "mg_excel_pdf_exports", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "fields_name"
    t.string "sorting_order_first_level"
    t.string "sorting_order_second_level"
    t.string "sorting_order_third_level"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_excess_fee_collections", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_school_id"
    t.integer "mg_time_table_id"
    t.integer "mg_batch_id"
    t.integer "mg_student_id"
    t.string "collection_name"
    t.integer "mg_account_id"
    t.date "collection_date"
    t.text "description"
    t.boolean "is_deleted"
    t.float "excess_amount"
    t.float "paid_amount"
    t.string "payment_status"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_school_id"], name: "index_mg_excess_fee_collections_on_mg_school_id"
    t.index ["mg_student_id"], name: "index_mg_excess_fee_collections_on_mg_student_id"
  end

  create_table "mg_expense_accesses", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "user_name"
    t.boolean "is_applicable"
    t.string "user_type"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_expense_budgets", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_time_table_id"
    t.float "amount"
    t.string "budget_name"
    t.integer "mg_expense_head_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_expense_head_id"], name: "index_mg_expense_budgets_on_mg_expense_head_id"
    t.index ["mg_school_id"], name: "index_mg_expense_budgets_on_mg_school_id"
    t.index ["mg_time_table_id"], name: "index_mg_expense_budgets_on_mg_time_table_id"
  end

  create_table "mg_expense_entries", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_expense_head_id"
    t.integer "mg_expense_item_id"
    t.date "date"
    t.string "item"
    t.integer "quantity"
    t.float "unit_price"
    t.float "total_amount"
    t.text "description"
    t.string "supported_bill"
    t.boolean "reimbursed"
    t.integer "mg_school_id"
    t.string "status"
    t.text "reason"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "bill_file"
    t.index ["mg_expense_head_id"], name: "index_mg_expense_entries_on_mg_expense_head_id"
    t.index ["mg_expense_item_id"], name: "index_mg_expense_entries_on_mg_expense_item_id"
    t.index ["mg_school_id"], name: "index_mg_expense_entries_on_mg_school_id"
  end

  create_table "mg_expense_heads", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_school_id"], name: "index_mg_expense_heads_on_mg_school_id"
  end

  create_table "mg_expense_histories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_expense_entry_id"
    t.string "past_status"
    t.string "current_status"
    t.datetime "updated_date", precision: nil
    t.string "updated_user"
    t.text "reason"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_expense_items", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_expense_head_id"
    t.string "item_name"
    t.text "description"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_expense_head_id"], name: "index_mg_expense_items_on_mg_expense_head_id"
    t.index ["mg_school_id"], name: "index_mg_expense_items_on_mg_school_id"
  end

  create_table "mg_extra_curricular_associations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_user_id"
    t.integer "mg_extra_curricular_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_extra_curriculars", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "is_deleted"
  end

  create_table "mg_fa_criteria", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "fa_name"
    t.text "description"
    t.integer "mg_fa_group_id"
    t.integer "sort_order"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_fa_groups", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "mg_cce_exam_category_id"
    t.integer "mg_cce_grades_set_id"
    t.float "max_marks"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "assessment"
  end

  create_table "mg_fa_groups_subjects", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_subject_id"
    t.integer "mg_fa_group_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "updated_by"
    t.integer "created_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_faq_categories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "category_name"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_faq_sub_categories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_faq_category_id"
    t.string "sub_category_name"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_faqs", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_faq_category_id"
    t.integer "mg_faq_sub_category_id"
    t.text "question"
    t.text "answer"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
  end

  create_table "mg_fcm_tokens", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_user_id"
    t.string "user_device_token"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_fee_categories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "item_category_name"
    t.integer "mg_inventory_item_category_id"
    t.integer "mg_inventory_item_id"
    t.integer "mg_account_id"
  end

  create_table "mg_fee_category_batches", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_batch_id"
    t.integer "mg_fee_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_fee_collection_discounts", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "mg_discount_type"
    t.string "mg_discount_name"
    t.integer "mg_discount_receiver_id"
    t.integer "mg_fee_collection_id"
    t.string "mg_discount"
    t.boolean "is_percent"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_fee_collection_id", "mg_school_id"], name: "mg_fee_collection_id"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_fee_collection_particulars", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "mg_fee_particular_name"
    t.string "mg_fee_particular_description"
    t.string "mg_fee_particular_amount"
    t.integer "mg_fee_collection_id"
    t.integer "mg_student_category_id"
    t.string "mg_student_admission_number"
    t.integer "mg_student_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "ignore_late_fee"
    t.index ["mg_fee_collection_id", "mg_student_id"], name: "mg_fee_collection_particular_index"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_fee_collections", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.integer "mg_fee_category_id"
    t.integer "mg_batch_id"
    t.integer "mg_fine_id"
    t.date "start_date"
    t.date "end_date"
    t.date "due_date"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "collection_type"
    t.integer "mg_fee_particular_id"
    t.index ["mg_school_id", "mg_batch_id"], name: "mg_school_id_2"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_fee_discounts", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "discount_type"
    t.string "name"
    t.integer "mg_receiver_id"
    t.integer "mg_batch_id"
    t.integer "mg_fee_category_id"
    t.string "discount"
    t.boolean "is_percent"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_account_id"
    t.boolean "is_to_central"
  end

  create_table "mg_fee_fine_dues", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_fee_fine_id"
    t.string "days_after_due_date"
    t.string "amount"
    t.boolean "is_percent"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_fee_fine_particulars", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "fine_name"
    t.text "description"
    t.string "fine_from"
    t.float "amount"
    t.integer "mg_batch_id"
    t.integer "mg_student_category_id"
    t.integer "mg_student_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.date "start_date"
    t.date "end_date"
    t.date "due_date"
    t.integer "mg_item_consumption_id"
    t.integer "mg_laboratory_subject_id"
    t.integer "mg_laboratory_room_id"
    t.integer "mg_inventory_item_id"
    t.integer "mg_inventory_fine_particular_id"
    t.integer "mg_account_id"
    t.boolean "is_to_central"
  end

  create_table "mg_fee_fines", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "fine_name"
    t.text "fine_description"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_account_id"
    t.boolean "is_to_central"
    t.string "late_fee_calculation_type"
  end

  create_table "mg_fee_otp_settings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "phone_number"
    t.integer "duration_in_minute"
    t.string "status"
    t.string "otp_type"
    t.integer "otp_length"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_fee_particulars", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "fee_category"
    t.string "name"
    t.string "description"
    t.date "start_date"
    t.date "end_date"
    t.date "due_date"
    t.string "amount"
    t.integer "mg_batch_id"
    t.integer "mg_particular_type_id"
    t.string "admission_no"
    t.integer "mg_student_category_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_account_id"
    t.boolean "is_to_central"
    t.index ["mg_school_id", "mg_batch_id"], name: "mg_school_id_2"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_fee_reciept_settings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "sequence_number"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_fee_registrations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.float "amount"
    t.integer "mg_wing_id"
    t.integer "mg_course_id"
    t.integer "mg_school_id"
    t.integer "mg_time_table_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_final_scholastic_scores", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_id"
    t.integer "mg_scholastic_exam_particular_id"
    t.float "final_marks"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_cbsc_exam_type_id"
    t.integer "mg_subject_id"
    t.integer "mg_batch_id"
    t.string "grade"
    t.integer "mg_subject_component_id"
    t.index ["mg_batch_id", "mg_student_id"], name: "mg_batch_id"
    t.index ["mg_school_id", "mg_batch_id"], name: "mg_school_id_2"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_finance_fees", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_fee_collection_id"
    t.string "transaction_id"
    t.integer "student_id"
    t.boolean "is_paid"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_school_id", "student_id"], name: "mg_school_id_2"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_finance_officers", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_employee_department_id"
    t.integer "mg_employee_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_finance_transaction_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_transaction_id"
    t.integer "mg_collection_id"
    t.integer "mg_student_id"
    t.integer "mg_fee_particular_id"
    t.integer "mg_fee_fine_particular_id"
    t.float "paid_amount"
    t.boolean "is_partial_payment"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_fee_collection_discount_id"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "late_fee_fine_id"
    t.string "detail_type"
    t.float "discount_amount"
    t.integer "mg_exces_id"
    t.index ["mg_collection_id", "mg_student_id"], name: "mg_finance_transaction_detail_index"
    t.index ["mg_school_id", "mg_transaction_id"], name: "mg_school_id_2"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_finance_transactions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "amount"
    t.boolean "fine_included"
    t.integer "category_id"
    t.integer "mg_student_id"
    t.integer "finance_fee_id"
    t.date "transaction_date"
    t.string "fine_amount"
    t.integer "master_transaction_id"
    t.integer "finance_id"
    t.string "finance_type"
    t.integer "payee_id"
    t.string "payee_type"
    t.string "receipt_no"
    t.string "voucher_no"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "payment_mode"
    t.date "date_of_cheque"
    t.date "date_of_draft"
    t.string "cheque_number"
    t.string "draft_number"
    t.string "bankname_and_branch"
    t.string "fees_from"
    t.string "collected_at"
    t.string "online_transaction_no"
    t.string "reason_for_deletion"
    t.string "cheque_status"
    t.integer "online_paid_amount"
    t.index ["mg_school_id", "mg_student_id"], name: "mg_school_id_2"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_financial_years", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "start_date", precision: nil
    t.datetime "end_date", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_fom_query_records", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_fom_transport_bookings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.date "date_of_booking"
    t.time "transport_time"
    t.string "place_from"
    t.string "place_to"
    t.string "way_mode"
    t.integer "mg_employee_category_id"
    t.integer "mg_employee_position_id"
    t.integer "mg_employee_id"
    t.text "purpose"
    t.string "status"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "remark"
    t.boolean "is_cancelled"
  end

  create_table "mg_food_items", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "item_name"
    t.integer "price"
    t.string "category"
    t.text "description"
    t.integer "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "unit"
    t.string "brand"
    t.integer "quantity"
  end

  create_table "mg_get_togethers", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_alumni_get_together_id"
    t.integer "mg_alumni_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_grade_components", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_employee_grade_id"
    t.integer "mg_salary_component_id"
    t.float "amount"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "is_applicable"
  end

  create_table "mg_grading_levels", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.integer "mg_batch_id"
    t.float "min_score"
    t.string "order"
    t.float "credit_points"
    t.text "description"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "scoring_type"
    t.integer "mg_time_table_id"
  end

  create_table "mg_greeting_messages", id: :integer, charset: "latin1", force: :cascade do |t|
    t.datetime "start_time", precision: nil
    t.datetime "end_time", precision: nil
    t.text "message"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "updated_by"
    t.integer "created_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_grouped_batches", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_batch_group_id"
    t.integer "mg_batch_id"
    t.integer "mg_school_id"
    t.integer "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_grouped_exam_reports", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_batch_id"
    t.integer "mg_student_id"
    t.integer "mg_exam_group_id"
    t.float "marks"
    t.string "score_type"
    t.integer "mg_subject_id"
    t.integer "mg_school_id"
    t.integer "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_grouped_exams", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_exam_group_id"
    t.integer "mg_batch_id"
    t.float "weightage"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_guardian_transport_requisitions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_id"
    t.integer "mg_transport_id"
    t.integer "mg_transport_time_management_id"
    t.string "confirmation_status"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.date "applied_date"
    t.integer "mg_vehicle_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_guardians", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_ward_id"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "relation"
    t.date "dob"
    t.integer "mg_country_id"
    t.string "occupation"
    t.string "income"
    t.string "education"
    t.integer "mg_user_id"
    t.integer "mg_student_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at", precision: nil
    t.string "adharnumber"
    t.boolean "is_archive"
    t.index ["mg_school_id", "mg_student_id"], name: "mg_school_id_2"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_guest_room_bookings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_fom_room_creation_id"
    t.date "start_date"
    t.date "end_date"
    t.integer "mg_employee_category_id"
    t.integer "mg_employee_position_id"
    t.integer "mg_employee_id"
    t.text "purpose"
    t.string "status"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "remark"
    t.boolean "is_cancelled"
  end

  create_table "mg_guests", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "guest_name"
    t.text "guest_details"
    t.string "mobile_no"
    t.string "email_id"
    t.string "status"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_event_id"
  end

  create_table "mg_health_tests", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_check_up_schedule_id"
    t.string "user_type"
    t.date "date"
    t.integer "mg_check_up_type_id"
    t.integer "mg_employee_department_id"
    t.integer "mg_batch_id"
    t.integer "mg_student_id"
    t.integer "mg_employee_id"
    t.string "result"
    t.string "recommendation"
    t.integer "mg_checkup_particular_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_help_documents", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_school_id"
    t.string "user_type"
    t.string "name"
    t.string "document_file_name"
    t.string "document_content_type"
    t.integer "document_file_size"
    t.datetime "document_updated_at", precision: nil
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_hobbies", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "is_deleted"
  end

  create_table "mg_hobby_associations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_user_id"
    t.integer "mg_hobby_id"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "is_deleted"
  end

  create_table "mg_holidays", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "holiday_name"
    t.date "holiday_date"
    t.text "description"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.date "holiday_start_date"
    t.date "holiday_end_date"
    t.boolean "is_for_student"
    t.boolean "is_for_employee"
    t.integer "mg_employee_category_id"
    t.string "applicable_for"
    t.integer "mg_time_table_id"
    t.string "holiday_code"
    t.text "mg_wing_id"
    t.boolean "payable"
  end

  create_table "mg_homework_categories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_hostel_attendances", id: :integer, charset: "latin1", force: :cascade do |t|
    t.date "absent_date"
    t.integer "mg_student_id"
    t.integer "mg_wing_id"
    t.integer "is_approved"
    t.boolean "is_lock"
    t.text "reason"
    t.text "morning_reason"
    t.text "evening_reason"
    t.text "morning_late_reason"
    t.text "evening_late_reason"
    t.string "time"
    t.string "evening_late_time"
    t.boolean "is_late_come"
    t.boolean "is_evening_late_come"
    t.boolean "absent_without_notice"
    t.integer "mg_hostel_detail_id"
    t.boolean "is_morning"
    t.boolean "is_evening"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_hostel_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "category"
    t.integer "total"
    t.integer "occupancy"
    t.integer "availability"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "visible_to_student"
  end

  create_table "mg_hostel_discipline_report_lists", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_hostel_discipline_report"
    t.integer "mg_student_id"
    t.string "status"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_hostel_discipline_reports", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_hostel_details_id"
    t.date "date_of_report"
    t.text "reason"
    t.text "action_to_be_taken"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "status"
  end

  create_table "mg_hostel_floors", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_user_id"
    t.integer "mg_hostel_details_id"
  end

  create_table "mg_hostel_going_out_provisions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.text "reason"
    t.date "from_date"
    t.time "start_time"
    t.date "to_date"
    t.time "end_time"
    t.string "status"
    t.integer "mg_student_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_hostel_details_id"
  end

  create_table "mg_hostel_health_managements", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_hostel_details_id"
    t.integer "mg_hostel_floor_id"
    t.integer "mg_hostel_room_id"
    t.integer "mg_student_id"
    t.date "date"
    t.text "reason"
    t.string "status"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_hostel_programme_quota", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_hostel_details_id"
    t.integer "programme"
    t.integer "max_occupancy"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_hostel_reallotment_requests", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_hostel_details_id"
    t.integer "mg_hostel_floor_id"
    t.integer "mg_hostel_room_type_id"
    t.integer "mg_wing_id"
    t.integer "mg_hostel_room_id"
    t.text "reason"
    t.string "status"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_student_id"
    t.string "reallocated_room__number"
  end

  create_table "mg_hostel_room_types", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "capacity"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_user_id"
    t.integer "mg_hostel_details_id"
  end

  create_table "mg_hostel_rooms", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_hostel_details_id"
    t.integer "mg_hostel_floor_id"
    t.integer "mg_hostel_room_type_id"
    t.string "name"
    t.integer "capacity"
    t.boolean "is_occupiable"
    t.text "reason"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "availability"
    t.boolean "is_occupiable_old"
  end

  create_table "mg_hostel_rules", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_hostel_details_id"
    t.string "name"
    t.text "description"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_hostel_wardens", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_hostel_details_id"
    t.integer "mg_employee_department_id"
    t.integer "mg_employee_id"
    t.string "user_name"
    t.integer "mg_user_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_house_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "Name"
    t.text "Description"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_images", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_alumni_photo_gallery_id"
    t.string "image"
    t.string "video"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "status"
  end

  create_table "mg_inventory_fine_particulars", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "fine_name"
    t.text "description"
    t.integer "amount"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_inventory_issued_item_consumptions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_inventory_item_consumption_id"
    t.string "mg_consumer_type"
    t.integer "mg_batch_id"
    t.integer "mg_student_id"
    t.integer "mg_department_id"
    t.integer "mg_employee_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_inventory_item_categories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_inventory_item_consumptions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_inventory_item_category_id"
    t.integer "mg_inventory_item_id"
    t.string "item_prefix"
    t.string "item_type"
    t.integer "mg_inventory_room_id"
    t.integer "mg_inventory_rack_id"
    t.integer "quantity_available"
    t.integer "quantity_consumed"
    t.integer "mg_school_id"
    t.date "consumption_date"
    t.string "consumption_type"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "description"
    t.integer "mg_student_id"
    t.integer "mg_employee_id"
  end

  create_table "mg_inventory_item_damageds", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_inventory_item_consumption_id"
    t.date "return_date"
    t.integer "mg_employee_id"
    t.integer "mg_student_id"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_inventory_item_managements", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_inventory_item_category_id"
    t.integer "mg_inventory_item_id"
    t.string "item_prefix"
    t.string "label_text"
    t.string "item_type"
    t.integer "mg_inventory_room_id"
    t.integer "mg_inventory_rack_id"
    t.integer "quantity"
    t.integer "minimum_quantity"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "quantity_available"
    t.date "date_of_expiry"
    t.string "remark"
  end

  create_table "mg_inventory_item_returns", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_inventory_item_consumption_id"
    t.date "return_date"
    t.integer "mg_employee_id"
    t.integer "mg_student_id"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_inventory_items", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.integer "mg_category_id"
    t.string "item_type"
    t.string "prefix"
    t.text "description"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "minimum_quantity_required"
    t.integer "mg_item_unit_id"
    t.boolean "available_online"
    t.bigint "reserved_for_offline"
    t.integer "online_price"
  end

  create_table "mg_inventory_managements", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_lab_id"
    t.integer "mg_category_id"
    t.string "item_name"
    t.text "item_description"
    t.decimal "quantity", precision: 10
    t.integer "mg_unit_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "item_identification_number"
    t.date "valid_upto"
    t.string "item_location"
    t.integer "mg_laboratory_subject_id"
    t.integer "mg_laboratory_room_id"
  end

  create_table "mg_inventory_projection_items", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_inventory_projection_id"
    t.integer "mg_item_id"
    t.integer "mg_unit_type_id"
    t.integer "no_of_unit"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_inventory_projections", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_store_id"
    t.integer "mg_employee_id"
    t.string "requisition_name"
    t.text "description"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.string "status"
    t.text "remark"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.date "date"
    t.integer "mg_user_id"
  end

  create_table "mg_inventory_proposal_items", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_inventory_proposal_id"
    t.integer "mg_item_id"
    t.integer "mg_unit_type_id"
    t.integer "no_of_unit"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "status"
    t.date "date"
    t.integer "mg_inventory_vendor_id"
    t.string "remark_description"
    t.string "po_number"
    t.string "invoice_number"
  end

  create_table "mg_inventory_proposals", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_store_id"
    t.integer "mg_employee_id"
    t.string "requisition_name"
    t.text "description"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.date "date"
    t.string "status"
    t.text "remark"
    t.integer "mg_account_id"
    t.integer "amount"
    t.boolean "is_from_central"
    t.integer "mg_user_id"
    t.string "code"
  end

  create_table "mg_inventory_room_managements", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "room_no"
    t.integer "mg_inventory_store_management_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_inventory_sales_data", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_inventory_item_category_id"
    t.date "date_of_sales"
    t.float "amount"
    t.integer "mg_inventory_item_id"
    t.float "cost_per_unit"
    t.float "no_of_units"
    t.float "total"
    t.integer "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_inventory_sales_information_id"
  end

  create_table "mg_inventory_sales_informations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_inventory_item_category_id"
    t.date "date_of_sales"
    t.float "amount"
    t.integer "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "customer_name"
    t.integer "mg_account_id"
    t.boolean "is_to_central"
  end

  create_table "mg_inventory_store_managements", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "store_name"
    t.text "description"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_inventory_store_managers", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_inventory_store_management_id"
    t.integer "mg_employee_department_id"
    t.integer "mg_employee_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_user_id"
  end

  create_table "mg_inventory_vendor_items", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_vendor_id"
    t.integer "mg_item_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "unit_price"
  end

  create_table "mg_inventory_vendors", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "category"
    t.string "name"
    t.string "contact_name"
    t.string "street_address"
    t.string "city"
    t.string "state"
    t.integer "postal_code"
    t.string "country"
    t.string "phone_number"
    t.string "fax_number"
    t.string "email"
    t.text "information"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "vendor_code"
  end

  create_table "mg_invitations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.boolean "employee"
    t.boolean "guardian"
    t.boolean "student"
    t.integer "mg_batch_id"
    t.integer "mg_employee_department_id"
    t.integer "mg_event_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "teacher"
    t.boolean "alumni"
    t.integer "time_table_year"
    t.integer "mg_wing_id"
  end

  create_table "mg_invite_get_togethers", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_wing_id"
    t.string "passout_year"
    t.integer "mg_alumni_get_together_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_invoice_associations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_school_id"
    t.integer "mg_invoice_generation_id"
    t.integer "mg_payment_schedule_child_id"
    t.string "invoice_generation_type"
    t.float "amount"
    t.string "description"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_invoice_generation_id"], name: "index_mg_invoice_associations_on_mg_invoice_generation_id"
    t.index ["mg_payment_schedule_child_id"], name: "index_mg_invoice_associations_on_mg_payment_schedule_child_id"
    t.index ["mg_school_id"], name: "index_mg_invoice_associations_on_mg_school_id"
  end

  create_table "mg_invoice_generations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_financial_year_id"
    t.integer "mg_school_id"
    t.string "invoice_number"
    t.string "temporary_invoice_number"
    t.datetime "date_of_invoice", precision: nil
    t.datetime "temporary_date_of_invoice", precision: nil
    t.datetime "due_date", precision: nil
    t.string "payment_cycle"
    t.string "invoice_type"
    t.float "due_amount"
    t.float "payable_amount"
    t.string "status"
    t.string "reason"
    t.float "igst_amount"
    t.float "tds_amount"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "total_students"
    t.float "rate_per_student"
    t.integer "mg_company_id"
    t.integer "mg_bank_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_financial_year_id"], name: "index_mg_invoice_generations_on_mg_financial_year_id"
    t.index ["mg_school_id"], name: "index_mg_invoice_generations_on_mg_school_id"
  end

  create_table "mg_item_consumptions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_lab_id"
    t.integer "mg_category_id"
    t.integer "mg_item_id"
    t.decimal "quantity_consumption", precision: 10
    t.date "date"
    t.string "consumption_type"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_course_id"
    t.integer "mg_batch_id"
    t.integer "mg_student_id"
    t.date "return_date"
    t.integer "mg_item_type_id"
    t.integer "mg_laboratory_subject_id"
    t.integer "mg_laboratory_room_id"
    t.integer "mg_laboratory_item_type_id"
  end

  create_table "mg_item_informations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_purchase_id"
    t.integer "mg_category_id"
    t.string "item_name"
    t.decimal "cost", precision: 10
    t.decimal "unit", precision: 10
    t.decimal "total", precision: 10
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.date "valid_upto"
  end

  create_table "mg_item_purchases", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_lab_id"
    t.string "vendor_name"
    t.date "date"
    t.decimal "amount_paid", precision: 10
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_laboratory_subject_id"
    t.integer "mg_room_id"
  end

  create_table "mg_lab_inventories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_lab_id"
    t.string "category_name"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_laboratory_item_id"
    t.string "prefix"
  end

  create_table "mg_lab_units", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "unit_name"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_laboratory_incharges", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_user_id"
    t.string "incharge_type"
    t.integer "mg_subject_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_laboratory_items", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "is_issuable"
  end

  create_table "mg_laboratory_subjects", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_labs", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "lab_name"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_laboratory_subject_id"
    t.string "room_no"
  end

  create_table "mg_languages", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_user_id"
    t.string "language_name"
    t.string "read"
    t.string "write"
    t.string "speak"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_library_access_permissions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_user_id"
    t.integer "mg_wing_id"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "fine_collection"
  end

  create_table "mg_library_employees", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_employee_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.string "designation"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_library_fine_dues", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_library_fine_id"
    t.string "days_after_due_date"
    t.string "amount"
    t.boolean "is_percent"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_library_fines", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "libray_fine_name"
    t.text "fine_description"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_account_id"
    t.boolean "is_to_central"
    t.string "late_fee_calculation_type"
  end

  create_table "mg_library_settings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "max_books_issuable"
    t.integer "max_borrow_days"
    t.float "fine_for_late_return"
    t.integer "max_days_on_reservation_after_return"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_fee_category_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_library_stack_managements", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "room_no"
    t.string "rack_no"
    t.string "first_letter_of_title"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_mail_statuses", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "status_code"
    t.string "email_addrs_to"
    t.string "email_addrs_by"
    t.string "email_subject"
    t.string "email_server_description"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_maintenance_sites", id: :integer, charset: "latin1", force: :cascade do |t|
    t.datetime "start_time", precision: nil
    t.datetime "end_time", precision: nil
    t.datetime "message_time", precision: nil
    t.text "message"
    t.boolean "is_deleted", default: false
    t.boolean "is_maintenance"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_manage_subjects", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_management_quota", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_user_id"
    t.string "name"
    t.string "position"
    t.string "employee_id"
    t.date "joining_date"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_master_data", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_financial_year_id"
    t.string "mg_state_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.float "installation_amount"
    t.integer "mg_agent_id"
    t.string "payment_cycle"
    t.string "payment_terms"
    t.string "payment_type"
    t.float "rate_per_student"
    t.integer "total_no_of_student"
    t.float "constant_amount"
    t.boolean "igst"
    t.boolean "tds"
    t.date "go_live_date"
    t.date "billing_start_date"
    t.integer "created_by"
    t.integer "updated_by"
    t.string "school_code"
    t.string "school_status"
    t.integer "mg_company_id"
    t.integer "mg_bank_id"
    t.integer "payment_slab"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_master_payment_types", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "mg_account_id"
    t.boolean "is_to_central"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_meal_categories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.integer "priority"
    t.text "description"
    t.integer "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_meeting_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_meeting_room_id"
    t.date "start_date"
    t.time "start_time"
    t.date "end_date"
    t.time "end_time"
    t.integer "mg_employee_id"
    t.text "meeting_purpose"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "number_of_attendees"
    t.boolean "is_cancelled"
  end

  create_table "mg_meeting_planner_foms", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "meeting_with"
    t.text "purpose"
    t.text "description"
    t.datetime "start_date_of_meeting", precision: nil
    t.time "start_time"
    t.time "end_time"
    t.string "status"
    t.text "remark"
    t.text "principal_remark"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "is_principal"
    t.datetime "end_date_of_meeting", precision: nil
    t.date "date_of_meeting"
    t.boolean "is_reschedule"
  end

  create_table "mg_meeting_rooms", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "room_no"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "type_of_room"
    t.integer "capacity"
  end

  create_table "mg_models", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "model_name"
    t.integer "index"
    t.string "description"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_multi_school_accesses", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_user_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_my_questions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "title"
    t.text "content", collation: "utf8_general_ci"
    t.integer "mg_employee_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_batch_id"
  end

  create_table "mg_notification_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_notification_id"
    t.integer "from_user_id"
    t.string "to_user_id"
    t.string "integer"
    t.string "user_type"
    t.string "subject"
    t.text "description"
    t.boolean "status"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["to_user_id", "mg_school_id"], name: "to_user_id"
  end

  create_table "mg_notification_documentations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_user_id"
    t.integer "mg_notification_id"
    t.string "user_type"
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at", precision: nil
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_notification_detail_id"
  end

  create_table "mg_notifications", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "from_user_id"
    t.integer "to_user_id"
    t.string "subject"
    t.text "description", collation: "utf8_general_ci"
    t.boolean "status"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_folder_id"
    t.string "notification_type"
    t.index ["mg_school_id", "to_user_id"], name: "mg_school_id_2"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_observation_groups", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "header_name"
    t.text "description"
    t.integer "mg_cce_grades_set_id"
    t.integer "observation_kind"
    t.string "max_marks_float"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_observations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "mg_observation_group_id"
    t.integer "sort_order"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "updated_by"
    t.integer "created_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_online_educations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_time_table_id"
    t.integer "mg_course_id"
    t.integer "mg_batch_id"
    t.integer "mg_subject_id"
    t.integer "mg_employee_id"
    t.integer "mg_syllabus_id"
    t.integer "mg_unit_id"
    t.integer "mg_topic_id"
    t.integer "mg_employee_folder_id"
    t.datetime "release_date", precision: nil
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_online_invigilator_records", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_subject_id"
    t.integer "mg_course_id"
    t.integer "mg_batch_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_question_paper_id"
    t.integer "mg_time_table_id"
    t.integer "mg_invigilator_id_1"
    t.integer "mg_invigilator_id_2"
    t.integer "mg_invigilator_id_3"
    t.integer "mg_invigilator_id_4"
    t.integer "mg_invigilator_id_5"
    t.integer "mg_invigilator_id_6"
    t.integer "mg_invigilator_id_7"
    t.integer "mg_invigilator_id_8"
    t.integer "mg_invigilator_id_9"
    t.integer "mg_invigilator_id_10"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_batch_id"], name: "index_mg_online_invigilator_records_on_mg_batch_id"
    t.index ["mg_course_id"], name: "index_mg_online_invigilator_records_on_mg_course_id"
    t.index ["mg_school_id"], name: "index_mg_online_invigilator_records_on_mg_school_id"
    t.index ["mg_subject_id"], name: "index_mg_online_invigilator_records_on_mg_subject_id"
  end

  create_table "mg_online_meetings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.integer "mg_video_configuration_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "mg_batch_id"
    t.datetime "meeting_date", precision: nil
    t.integer "mg_batch_subject_id"
    t.integer "mg_time_table_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "sunday"
    t.boolean "monday"
    t.boolean "tuesday"
    t.boolean "wednesday"
    t.boolean "thursday"
    t.boolean "friday"
    t.boolean "saturday"
    t.string "start_time"
    t.string "end_time"
    t.text "online_class_detail"
    t.text "meeting_id_detail"
    t.text "description"
  end

  create_table "mg_online_module_permissions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_model_id"
    t.integer "mg_permitted_model_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_school_id"], name: "index_mg_online_module_permissions_on_mg_school_id"
  end

  create_table "mg_online_payment_params", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_school_id"
    t.string "status"
    t.text "description", collation: "utf8_general_ci"
    t.string "payment_gateway"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "session_params"
    t.string "txn_id"
    t.text "payu_reverse_hash"
    t.text "mg_reverse_hash"
    t.integer "additional_charges"
    t.integer "created_by"
    t.integer "updated_by"
    t.string "device_type"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_online_payments", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_school_id"
    t.string "merchant_key"
    t.string "merchant_salt"
    t.string "merchant_id"
    t.string "attribute1"
    t.string "attribute2"
    t.string "attribute3"
    t.string "payment_gateway"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_wing_id"
    t.boolean "is_partial_fee_applicable"
    t.string "request_hash_key"
    t.string "response_hash_key"
    t.string "mode"
    t.string "device_type"
    t.string "merchant_name"
    t.string "mcc_code"
    t.index ["mg_school_id", "mg_wing_id"], name: "mg_school_id"
    t.index ["mg_school_id"], name: "mg_school_id_2"
  end

  create_table "mg_online_question_types", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "question_type"
    t.string "qtype_code"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_page_hit_counts", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "url"
    t.integer "count"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.date "date"
    t.integer "mg_school_id"
  end

  create_table "mg_parent_previous_educations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_admission_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.string "from_year"
    t.string "to_year"
    t.string "from_class"
    t.string "to_class"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_school_id"], name: "index_mg_parent_previous_educations_on_mg_school_id"
    t.index ["mg_student_admission_id"], name: "index_mg_parent_previous_educations_on_mg_student_admission_id"
  end

  create_table "mg_particular_types", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "particular_name"
    t.string "description"
    t.integer "mg_fee_category_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_inventory_item_id"
  end

  create_table "mg_password_trackers", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_user_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.datetime "start_date", precision: nil
    t.datetime "end_date", precision: nil
    t.integer "reset_count"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_payment_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "school_code"
    t.integer "mg_school_id"
    t.text "json_data"
    t.integer "created_by"
    t.integer "updated_by"
    t.string "transaction_status"
    t.string "txn_id"
    t.string "gateway_txn_id"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_payment_gateways", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_master_payment_type_id"
    t.integer "mg_wing_id"
    t.string "time_table_year"
    t.integer "mg_employee_specialization_id"
    t.integer "mg_alumni_id"
    t.float "amount"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "upated_by"
    t.integer "mg_finance_fee_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_account_id"
    t.boolean "is_to_central"
  end

  create_table "mg_payment_schedule_children", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "start_date"
    t.string "end_date"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_payment_schedule_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_payment_schedule_id"], name: "index_mg_payment_schedule_children_on_mg_payment_schedule_id"
  end

  create_table "mg_payment_schedules", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "payment_cycle"
    t.string "billing_date"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "mg_financial_year_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_financial_year_id"], name: "index_mg_payment_schedules_on_mg_financial_year_id"
    t.index ["mg_school_id"], name: "index_mg_payment_schedules_on_mg_school_id"
  end

  create_table "mg_payment_types", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "payment_type_name"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_payslip_leave_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_employee_payslip_detail_id"
    t.integer "mg_employee_leave_type_id"
    t.float "leave_taken"
    t.float "available_leave"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_payu_bizz_audit_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "mihpayid"
    t.string "status"
    t.string "key"
    t.string "txnid"
    t.float "amount"
    t.float "net_amount_debit"
    t.string "added_on"
    t.string "first_name"
    t.string "email"
    t.string "phone"
    t.string "field1"
    t.string "field2"
    t.string "field3"
    t.string "field4"
    t.string "field5"
    t.string "field6"
    t.string "field7"
    t.string "field8"
    t.string "field9"
    t.string "field10"
    t.string "pg_type"
    t.string "bank_ref_num"
    t.string "error"
    t.string "error_Message"
    t.string "card_num"
    t.string "mg_school_id"
    t.string "fee_collection_ids"
    t.string "collection_particular_ids"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_online_payment_param_id"
    t.string "payment_gateway"
    t.string "payment_by"
    t.index ["status", "txnid"], name: "mg_payu_bizz_audit_detail_index", unique: true
  end

  create_table "mg_periodic_test_components", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_cbsc_exam_id"
    t.integer "mg_cbsc_exam_perticular_id"
    t.string "periodic_test_component"
    t.text "description"
    t.integer "weightage"
    t.integer "max_marks"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_permissions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_model_id"
    t.integer "mg_action_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_phones", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "phone_number"
    t.string "phone_type"
    t.boolean "notification"
    t.boolean "subscription"
    t.integer "mg_user_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_school_id"], name: "mg_school_id"
    t.index ["mg_user_id", "mg_school_id"], name: "mg_user_id"
  end

  create_table "mg_placement_student_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "resume_headline"
    t.string "current_position"
    t.date "date_of_birth"
    t.string "last_degree"
    t.string "year_of_passing"
    t.string "functional_area"
    t.string "educational_qualification"
    t.integer "experience"
    t.text "technical_skills"
    t.text "soft_skills"
    t.integer "salary_expected"
    t.text "address"
    t.integer "contact_number"
    t.string "email_id"
    t.string "current_location"
    t.string "preferred_location"
    t.integer "mg_student_id"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_poll_data", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_question_id"
    t.integer "mg_alumni_user_id"
    t.integer "answer"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_poll_option_alumni_particulars", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_poll_option_alumni_id"
    t.string "paticular"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "count"
  end

  create_table "mg_poll_option_alumnis", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_alumni_polling_id"
    t.string "paticular"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_poll_question_alumnis", id: :integer, charset: "latin1", force: :cascade do |t|
    t.text "question"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.date "due_date"
    t.date "start_date"
  end

  create_table "mg_postal_records", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "recipient_name"
    t.text "address"
    t.string "dispatch_number"
    t.string "transaction_flow"
    t.date "received_date"
    t.string "mode_of_dispatch"
    t.string "category"
    t.string "dispatcher"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "user_type"
    t.integer "mg_batch_id"
    t.integer "mg_student_id"
    t.integer "mg_employee_department_id"
    t.integer "mg_employee_id"
  end

  create_table "mg_previous_educations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "school_name"
    t.string "course"
    t.string "grade"
    t.integer "year"
    t.integer "mg_student_id"
    t.integer "marks_obtained"
    t.decimal "total_marks", precision: 10
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "is_transfer_certificate_produced"
    t.boolean "is_previous_education"
    t.index ["mg_school_id"], name: "mg_school_id"
    t.index ["mg_school_id"], name: "mg_school_id_2"
  end

  create_table "mg_query_records", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "query_number"
    t.string "caller_name"
    t.string "phone_number"
    t.integer "mg_caller_category_fom_id"
    t.text "query"
    t.integer "mg_fom_query_record_id"
    t.text "response_given"
    t.text "follow_up_action"
    t.text "action_required"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "is_principal_required"
    t.integer "mg_caller_category_id"
    t.date "date_of_query"
  end

  create_table "mg_question_banks", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_batch_id"
    t.integer "mg_syllabus_id"
    t.integer "mg_chapter_id"
    t.integer "mg_topic_id"
    t.integer "mg_question_type_id"
    t.text "description", collation: "utf8_general_ci"
    t.float "mark"
    t.string "mg_difficulty_level"
    t.integer "mg_blooms_level"
    t.text "mg_question_key", collation: "utf8_general_ci"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_image_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_question_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_school_id"
    t.integer "mg_question_bank_id"
    t.text "name", collation: "utf8_general_ci"
    t.boolean "is_deleted"
    t.boolean "is_answer"
    t.integer "mg_image_id"
    t.integer "mg_sub_question_bank_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_question_bank_id"], name: "index_mg_question_details_on_mg_question_bank_id"
    t.index ["mg_school_id"], name: "index_mg_question_details_on_mg_school_id"
  end

  create_table "mg_question_set_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_question_set_id"
    t.text "section_name", collation: "utf8_general_ci"
    t.integer "mg_question_bank_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_question_bank_id"], name: "index_mg_question_set_details_on_mg_question_bank_id"
    t.index ["mg_question_set_id"], name: "index_mg_question_set_details_on_mg_question_set_id"
    t.index ["mg_school_id"], name: "index_mg_question_set_details_on_mg_school_id"
  end

  create_table "mg_question_sets", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "set_name"
    t.integer "mg_create_question_paper_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_create_question_paper_id"], name: "index_mg_question_sets_on_mg_create_question_paper_id"
    t.index ["mg_school_id"], name: "index_mg_question_sets_on_mg_school_id"
  end

  create_table "mg_ranking_levels", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.float "gpa"
    t.float "marks"
    t.integer "subject_count"
    t.integer "priority"
    t.integer "full_course"
    t.integer "mg_course_id"
    t.string "subject_limit_type"
    t.string "marks_limit_type"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_rbac_news", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "mg_submodule_menu"
    t.integer "mg_school_id"
    t.integer "role_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mg_registration_fee_collections", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "student_name"
    t.integer "mg_fee_registration_id"
    t.integer "mg_course_id"
    t.integer "mg_school_id"
    t.string "form_no"
    t.datetime "collection_date", precision: nil
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_fee_registration_id"], name: "index_mg_registration_fee_collections_on_mg_fee_registration_id"
    t.index ["mg_school_id"], name: "index_mg_registration_fee_collections_on_mg_school_id"
  end

  create_table "mg_regular_fee_collection_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "particular_name"
    t.float "fee_amount"
    t.integer "mg_regular_fee_collection_id"
    t.boolean "is_deleted"
    t.integer "mg_student_admission_request_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.float "fee_paid"
    t.float "remaining_amount"
  end

  create_table "mg_regular_fee_collections", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "reference_id"
    t.date "payment_date"
    t.string "payment_type"
    t.string "random_security_code"
    t.integer "mg_student_admission_request_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "programme_name"
    t.float "amount"
    t.string "programme_type"
    t.string "mobile_number"
    t.string "transaction_id"
  end

  create_table "mg_remarks_entries", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "remarks"
    t.integer "index"
    t.string "remarks_type"
    t.integer "mg_time_table_id"
    t.integer "mg_course_id"
    t.integer "mg_batch_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_report_card_setups", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_time_table_id"
    t.integer "mg_wing_id"
    t.integer "mg_course_id"
    t.integer "mg_batch_id"
    t.boolean "term_wise"
    t.boolean "scholastic"
    t.boolean "co_scholastic"
    t.boolean "rank"
    t.boolean "remarks"
    t.boolean "remark_one"
    t.boolean "remark_two"
    t.boolean "remark_three"
    t.boolean "remark_four"
    t.boolean "attendance"
    t.boolean "attendance_one"
    t.boolean "attendance_two"
    t.boolean "attendance_three"
    t.boolean "attendance_four"
    t.boolean "attendance_five"
    t.boolean "result"
    t.boolean "height_weight"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_cbsc_exam_type_id"
    t.boolean "subjects"
    t.boolean "subject_two"
  end

  create_table "mg_report_front_page_settings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_wing_id"
    t.integer "mg_batch_id"
    t.string "report_parameter"
    t.integer "y_axis"
    t.integer "x_axis"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_report_print_settings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_wing_id"
    t.integer "mg_batch_id"
    t.integer "page_width"
    t.integer "page_height"
    t.integer "scholastic_x_index_difference"
    t.integer "scholastic_y_index_difference"
    t.integer "scholastic_x_origin"
    t.integer "scholastic_y_origin"
    t.string "scholastic_report_orientation"
    t.integer "other_x_index_difference"
    t.integer "other_y_index_difference"
    t.integer "other_x_origin"
    t.integer "other_y_origin"
    t.string "other_report_orientation"
    t.boolean "other_report_is_in_new_page"
    t.text "description"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "x_axis"
  end

  create_table "mg_report_request_dates", id: :integer, charset: "latin1", force: :cascade do |t|
    t.date "request_date"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_time_table_id"
    t.integer "mg_batch_id"
    t.integer "mg_school_id"
    t.integer "mg_student_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_batch_id"], name: "index_mg_report_request_dates_on_mg_batch_id"
    t.index ["mg_school_id"], name: "index_mg_report_request_dates_on_mg_school_id"
    t.index ["mg_student_id"], name: "index_mg_report_request_dates_on_mg_student_id"
    t.index ["mg_time_table_id"], name: "index_mg_report_request_dates_on_mg_time_table_id"
  end

  create_table "mg_report_types", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "report_type_name"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_resource_categories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_wing_id"
  end

  create_table "mg_resource_informations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_resource_category_id"
    t.integer "mg_resource_type_id"
    t.string "name"
    t.string "author"
    t.string "volume"
    t.integer "year"
    t.string "publication"
    t.string "isbn"
    t.string "mg_course_id"
    t.integer "mg_subject_id"
    t.float "cost"
    t.integer "no_of_copy"
    t.float "total"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_resource_purchase_id"
  end

  create_table "mg_resource_inventories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_resource_category_id"
    t.integer "mg_resource_type_id"
    t.string "resource_number", collation: "utf8_general_ci"
    t.text "name", size: :long, collation: "utf8_general_ci"
    t.string "author", collation: "utf8_general_ci"
    t.string "volume"
    t.string "year"
    t.string "publication", collation: "utf8_general_ci"
    t.string "isbn"
    t.string "mg_course_id"
    t.integer "mg_subject_id"
    t.string "stack_reference"
    t.float "cost"
    t.boolean "non_issuable"
    t.boolean "is_damaged"
    t.boolean "is_lost"
    t.string "status"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "issued_to"
    t.date "due_date"
    t.date "issued_date"
    t.string "user_type"
    t.integer "renewal_count"
    t.integer "reserve_student_id"
    t.integer "reserve_max_days"
    t.date "last_return_date"
    t.date "reserve_date"
  end

  create_table "mg_resource_purchases", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "vendor_name"
    t.date "date_of_purchase"
    t.float "amount_paid"
    t.string "invoice_number"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_resource_type_associations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_resource_type_id"
    t.string "user_type"
    t.integer "max_issuable_count"
    t.integer "max_borrow_day"
    t.integer "renewal_period"
    t.integer "max_renewals_allowed"
    t.float "fine_per_day"
    t.boolean "is_non_issuable"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "restricted_issue_days"
    t.integer "reserve_period"
    t.index ["mg_resource_type_id"], name: "index_mg_resource_type_associations_on_mg_resource_type_id"
  end

  create_table "mg_resource_types", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "mg_resource_category_id"
    t.integer "max_issuable_count"
    t.integer "max_borrow_day"
    t.integer "renewal_period"
    t.integer "max_renewals_allowed"
    t.string "prefix"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.float "fine_per_day"
    t.boolean "is_non_issuable"
  end

  create_table "mg_rexam_student_lists", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_id"
    t.integer "mg_subject_id"
    t.integer "mg_batch_id"
    t.integer "mg_course_id"
    t.integer "mg_school_id"
    t.integer "mg_create_question_paper_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_batch_id"], name: "index_mg_rexam_student_lists_on_mg_batch_id"
    t.index ["mg_course_id"], name: "index_mg_rexam_student_lists_on_mg_course_id"
    t.index ["mg_create_question_paper_id"], name: "index_mg_rexam_student_lists_on_mg_create_question_paper_id"
    t.index ["mg_school_id"], name: "index_mg_rexam_student_lists_on_mg_school_id"
    t.index ["mg_student_id"], name: "index_mg_rexam_student_lists_on_mg_student_id"
    t.index ["mg_subject_id"], name: "index_mg_rexam_student_lists_on_mg_subject_id"
  end

  create_table "mg_roles", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "role_name"
    t.string "description"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_school_id"
    t.boolean "is_subsim"
    t.boolean "dashboard"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_roles_permissions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_role_id"
    t.integer "mg_permission_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_school_id"
  end

  create_table "mg_salary_components", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.boolean "is_deduction"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_account_id"
    t.boolean "is_from_central"
    t.integer "index"
    t.string "belongs_to"
    t.boolean "is_leave"
    t.text "formula"
    t.string "calculation_type"
    t.integer "percentage"
    t.string "belong_to_calculation"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_scholastic_exam_components", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_scholastic_exam_particular_id"
    t.string "name"
    t.string "description"
    t.integer "weightage"
    t.integer "max_marks"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "display_name"
    t.string "calculation"
    t.string "calculation_fields"
    t.integer "best_of_count"
    t.string "formula"
    t.string "internal_name"
  end

  create_table "mg_scholastic_exam_particulars", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "calculation"
    t.integer "best_of_count"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "weightage"
    t.integer "index"
    t.integer "mg_time_table_id"
    t.string "formula"
    t.string "internal_name"
    t.string "calculation_fields"
    t.string "display_name"
    t.boolean "round"
    t.string "no_of_decimal"
    t.integer "mg_cbsc_exam_type_id"
    t.boolean "rank"
    t.string "rank_type"
    t.string "absent_reason"
    t.boolean "grade_particular"
    t.boolean "consolidated"
    t.boolean "graph"
  end

  create_table "mg_scholastic_grades_stores", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_school_id"
    t.integer "mg_time_table_id"
    t.integer "mg_batch_id"
    t.integer "mg_cbsc_exam_type_id"
    t.integer "mg_subject_id"
    t.integer "mg_student_id"
    t.string "total_marks"
    t.string "grade"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_batch_id"], name: "index_mg_scholastic_grades_stores_on_mg_batch_id"
    t.index ["mg_cbsc_exam_type_id"], name: "index_mg_scholastic_grades_stores_on_mg_cbsc_exam_type_id"
    t.index ["mg_school_id"], name: "index_mg_scholastic_grades_stores_on_mg_school_id"
    t.index ["mg_student_id"], name: "index_mg_scholastic_grades_stores_on_mg_student_id"
    t.index ["mg_subject_id"], name: "index_mg_scholastic_grades_stores_on_mg_subject_id"
    t.index ["mg_time_table_id"], name: "index_mg_scholastic_grades_stores_on_mg_time_table_id"
  end

  create_table "mg_scholastic_ranks", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_time_table_id"
    t.integer "mg_student_id"
    t.string "student_name"
    t.integer "mg_batch_id"
    t.integer "mg_course_id"
    t.string "total_marks"
    t.string "obtained_marks"
    t.string "rank"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.string "mg_cbsc_exam_type_id"
    t.string "rank_type"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "rank_calculation_type"
    t.string "mg_scholastic_particular_id"
    t.string "mg_scholastic_components_id"
  end

  create_table "mg_school_account_data_uploads", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "mg_upload_type"
    t.string "file_name"
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at", precision: nil
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.date "file_date"
    t.string "department"
  end

  create_table "mg_school_additional_params", id: :integer, charset: "latin1", force: :cascade do |t|
    t.boolean "is_multiple_class_teacher"
    t.boolean "is_multiple_section_subject"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_school_programmes", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.integer "amount"
    t.string "secret_key"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.string "attribute_1"
    t.string "attribute_2"
    t.string "school_url"
    t.string "programme_type"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "school_code"
    t.float "semester_fee_1"
    t.float "semester_fee_2"
    t.float "practical_fee"
  end

  create_table "mg_school_rbacs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "sub_module_menu"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mg_schools", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "school_name"
    t.string "school_code"
    t.string "address_line1"
    t.string "address_line2"
    t.string "country"
    t.integer "country_code"
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at", precision: nil
    t.string "start_time"
    t.string "end_time"
    t.string "street"
    t.string "city"
    t.string "state"
    t.integer "pin_code"
    t.string "landmark"
    t.string "mobile_number"
    t.string "email_id"
    t.string "fax_number"
    t.string "language"
    t.string "date_format"
    t.string "timezone"
    t.text "currency_type", collation: "utf8_general_ci"
    t.string "affilicated_to"
    t.string "grading_system"
    t.binary "school_logo"
    t.string "reg_num"
    t.boolean "is_active"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "subdomain"
    t.date "mg_leave_calendar_start_date"
    t.boolean "is_test_center"
    t.boolean "disable_entrance_exam_test"
    t.integer "exam_mg_fee_category_id"
    t.integer "mg_fee_category_id"
    t.boolean "sms_enable"
    t.string "school_status", default: "active"
    t.boolean "sms_config"
    t.string "days_in_month", default: "as_is"
    t.date "payslip_start_date"
    t.boolean "show_balance", default: false
    t.float "minimum_age", default: 3.0
    t.boolean "show_yearly_amount"
    t.boolean "is_online_payment"
    t.string "reset_password_type"
    t.boolean "due_date_check"
    t.integer "fee_by_range"
    t.index ["subdomain"], name: "subdomain"
  end

  create_table "mg_section_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_create_question_paper_id"
    t.string "section_name"
    t.integer "mg_question_type_id"
    t.integer "total_question"
    t.float "total_marks"
    t.float "marks_per_question"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_create_question_paper_id"], name: "index_mg_section_details_on_mg_create_question_paper_id"
    t.index ["mg_school_id"], name: "index_mg_section_details_on_mg_school_id"
  end

  create_table "mg_section_mark_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_create_question_paper_id"
    t.integer "mg_question_type_id"
    t.text "section_name", collation: "utf8_general_ci"
    t.integer "total_question"
    t.integer "total_marks"
    t.float "marks_per_question"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_chapter_id"
    t.index ["mg_create_question_paper_id"], name: "index_mg_section_mark_details_on_mg_create_question_paper_id"
    t.index ["mg_school_id"], name: "index_mg_section_mark_details_on_mg_school_id"
  end

  create_table "mg_siblings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_user_id"
    t.string "name"
    t.string "relation"
    t.integer "mg_course_id"
    t.integer "mg_batch_id"
    t.string "roll_no"
    t.date "admission_date"
    t.string "admission_no"
    t.boolean "is_sibling"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_sms_addion_attributes", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "mg_sms_configuration_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_sms_configuration_id"], name: "index_mg_sms_addion_attributes_on_mg_sms_configuration_id"
  end

  create_table "mg_sms_additional_attributes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.integer "is_deleted"
    t.integer "mg_school_id"
    t.integer "sms_configuration_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mg_sms_configerations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "url"
    t.boolean "support_multiple_sms"
    t.integer "maximum_sms_Support"
    t.string "mobile_number_attribute"
    t.string "msg_attribute"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "sender_id"
    t.string "sender_id_value"
    t.string "request_type"
    t.string "english_key"
    t.string "english_value"
    t.string "unicode_key"
    t.string "unicode_value"
  end

  create_table "mg_sms_count_month_wises", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_sms_count_settings_id"
    t.date "month"
    t.integer "count_of_sms_used"
    t.integer "exceeded_sms_count"
    t.integer "carry_forward_sms_count"
    t.float "exceeded_sms_cost"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "available_sms"
    t.integer "mg_school_id"
    t.integer "total_sms"
  end

  create_table "mg_sms_count_settings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_school_id"
    t.integer "limit"
    t.float "cost"
    t.integer "max_carry_forward_limit"
    t.date "start_date_active"
    t.date "end_date_active"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "is_deleted"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_sms_details", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "mg_sms_request_id"
    t.string "user_name"
    t.integer "to_user_id"
    t.integer "from_user_id"
    t.date "date"
    t.text "response"
    t.string "status", default: "Pending"
    t.string "mobile_number"
    t.string "from_module"
    t.boolean "is_deleted", default: false
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_user_id"], name: "index_mg_sms_details_on_from_user_id"
    t.index ["mg_school_id"], name: "index_mg_sms_details_on_mg_school_id"
    t.index ["mg_sms_request_id"], name: "index_mg_sms_details_on_mg_sms_request_id"
    t.index ["to_user_id"], name: "index_mg_sms_details_on_to_user_id"
  end

  create_table "mg_sms_priorities", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_sms_configeration_id"
    t.integer "priority"
    t.string "sender_id"
    t.string "sender_id_value"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "vendor_name"
  end

  create_table "mg_sms_requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "from_user_id"
    t.string "sms_type"
    t.text "message"
    t.integer "mg_school_id"
    t.string "status"
    t.string "receiver_type"
    t.integer "receiver_id"
    t.integer "template_id"
    t.integer "pe_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "is_deleted"
    t.index ["from_user_id"], name: "index_mg_sms_requests_on_from_user_id"
    t.index ["mg_school_id"], name: "index_mg_sms_requests_on_mg_school_id"
  end

  create_table "mg_specializations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_sport_employee_data_results", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_sports_result_id"
    t.integer "mg_employee_id"
    t.string "rank"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_sport_games", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "game_type"
    t.text "description"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "activity_game_type"
  end

  create_table "mg_sport_payslip_components", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_employee_payslip_detail_id"
    t.integer "mg_sports_pay_deduction_id"
    t.integer "amount"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "deduction"
  end

  create_table "mg_sport_schedules", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "game_type"
    t.integer "mg_sport_game_id"
    t.integer "mg_sport_team_id1"
    t.integer "mg_sport_team_id2"
    t.string "guest_team"
    t.date "start_date"
    t.time "start_time"
    t.date "end_date"
    t.time "end_time"
    t.string "venue"
    t.string "winner"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_sport_student_data_results", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_sports_result_id"
    t.integer "mg_students_id"
    t.string "rank"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_sport_team_employees", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_sport_team_id"
    t.integer "mg_employee_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_sport_team_students", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_sport_team_id"
    t.integer "mg_student_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_sport_teams", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "game_type"
    t.integer "mg_sport_game_id"
    t.string "team_name"
    t.string "team_of"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_sports", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "is_deleted"
  end

  create_table "mg_sports_associations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_user_id"
    t.integer "mg_sport_id"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "is_deleted"
  end

  create_table "mg_sports_bed_assignments", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_sports_bed_details_id"
    t.date "admitted_date"
    t.time "admitted_time"
    t.date "discharge_date"
    t.time "discharge_time"
    t.string "user_id"
    t.string "status"
    t.integer "mg_doctor_id"
    t.text "comments"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_sports_bed_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "bed_no"
    t.text "description"
    t.string "status"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_sports_fine_students", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_sports_fine_id"
    t.integer "mg_student_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_sports_fines", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "fine_name"
    t.text "description"
    t.integer "mg_account_id"
    t.integer "amount"
    t.integer "mg_batches_id"
    t.integer "mg_student_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_sports_item_consumptions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_inventory_item_category_id"
    t.integer "mg_inventory_item_id"
    t.string "item_prefix"
    t.string "item_type"
    t.integer "mg_inventory_room_id"
    t.integer "mg_inventory_rack_id"
    t.integer "quantity_available"
    t.integer "quantity_consumed"
    t.string "consumption_type"
    t.date "consumption_date"
    t.text "description"
    t.integer "mg_student_id"
    t.integer "mg_employee_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_sports_item_managements", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_inventory_item_category_id"
    t.integer "mg_inventory_item_id"
    t.string "item_prefix"
    t.string "label_text"
    t.integer "mg_inventory_room_id"
    t.integer "mg_inventory_rack_id"
    t.integer "quantity"
    t.integer "quantity_available"
    t.date "date_of_expiry"
    t.text "remark"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_sports_pay_deductiion_lists", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_pay_deduction_details_id"
    t.integer "mg_employee_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_sports_pay_deductions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "mm_yyyy"
    t.integer "mg_employee_category_id"
    t.integer "mg_employee_department_id"
    t.integer "mg_employee_id"
    t.integer "amount"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "name"
    t.boolean "is_central"
    t.boolean "is_account"
    t.integer "month"
    t.integer "year"
    t.boolean "deduction"
  end

  create_table "mg_sports_results", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_event_committee_id"
    t.integer "mg_event_id"
    t.date "date_of_event"
    t.integer "mg_sport_game_id"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "game_type"
    t.integer "mg_sport_team_id1"
    t.integer "mg_sport_team_id2"
    t.string "guest_team"
    t.text "venue"
    t.text "winner"
    t.string "sport_type"
    t.integer "mg_sport_team_id"
  end

  create_table "mg_states", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_student_additional_request_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "obt_marks"
    t.string "roll_no"
    t.integer "passing_year"
    t.string "board"
    t.integer "max_marks"
    t.integer "intermediate_year_passed"
    t.string "intermediate_roll_no"
    t.integer "intermediate_percentage"
    t.integer "intermediate_max_marks"
    t.integer "intermediate_marks_obt"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_educational_id"
    t.integer "mg_student_admission_request_id"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at", precision: nil
    t.string "signature_file_name"
    t.string "signature_content_type"
    t.integer "signature_file_size"
    t.datetime "signature_updated_at", precision: nil
    t.string "high_school_marks_sheet_file_name"
    t.string "high_school_marks_sheet_content_type"
    t.integer "high_school_marks_sheet_file_size"
    t.datetime "high_school_marks_sheet_updated_at", precision: nil
    t.string "intermediate_marks_sheet_file_name"
    t.string "intermediate_marks_sheet_content_type"
    t.integer "intermediate_marks_sheet_file_size"
    t.datetime "intermediate_marks_sheet_updated_at", precision: nil
    t.string "adhar_file_name"
    t.string "adhar_content_type"
    t.integer "adhar_file_size"
    t.datetime "adhar_updated_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "graduation_year_passed"
    t.string "graduation_year_roll_no"
    t.string "graduation_year_college_name"
    t.string "graduation_year_college_university"
    t.integer "graduation_year_percentage"
    t.integer "graduation_year_college_max_marks"
    t.integer "graduation_year_college_marks_obt"
    t.string "school_name"
    t.float "percentage"
    t.string "intermediate_board"
  end

  create_table "mg_student_admission_payment_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_admission_fee_particular_id"
    t.string "particular_name"
    t.float "fee_amount"
    t.integer "mg_student_admission_request_id"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "created_by"
    t.integer "updated_by"
    t.float "paid_amount"
    t.float "remaining_amount"
    t.string "reference_id"
    t.date "payment_date"
    t.string "random_security_code"
    t.string "payment_type"
  end

  create_table "mg_student_admission_requests", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "programme_type"
    t.string "programme_name"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.date "date_of_birth"
    t.string "email_id"
    t.string "mobile_number"
    t.string "father_first_name"
    t.string "father_middle_name"
    t.string "father_last_name"
    t.string "mother_first_name"
    t.string "mother_middle_name"
    t.string "mother_last_name"
    t.text "address_line_1"
    t.text "address_line_2"
    t.string "country"
    t.integer "pincode"
    t.string "district"
    t.string "gender"
    t.string "category"
    t.string "caste_certificate_number"
    t.string "nationality"
    t.string "religion"
    t.string "sub_category"
    t.boolean "is_father_income_check"
    t.string "income_certificate_number"
    t.string "blood_group"
    t.string "id_proof"
    t.string "id_number"
    t.string "adhar_number"
    t.text "correspondence_line_1"
    t.text "correspondence_line_2"
    t.string "correspondence_country"
    t.integer "correspondence_pincode"
    t.string "correspondence_district"
    t.string "correspondence_mobile"
    t.string "correspondence_alt_number"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_educational_id"
    t.float "amount"
    t.string "organisation_type"
    t.text "examination_body"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "state"
    t.string "correspondence_state"
    t.string "payment_type"
    t.string "reference_id"
    t.date "payment_date"
    t.boolean "is_paid"
    t.string "transaction_id"
    t.string "random_security_code"
    t.text "subject_details"
    t.string "course_type"
    t.date "admission_date"
    t.string "academic_year"
  end

  create_table "mg_student_admissions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.date "date_of_birth"
    t.integer "mg_course_id"
    t.string "grade"
    t.integer "year"
    t.string "course"
    t.boolean "is_sibling"
    t.string "is_selected_for_entrance_test"
    t.string "is_shortlisted_for_admission"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "gender"
    t.string "blood_group"
    t.string "birth_place"
    t.string "nationality"
    t.string "language"
    t.string "religion"
    t.string "mg_c_address_line1"
    t.string "mg_c_address_line2"
    t.string "mg_c_street"
    t.string "mg_c_landmark"
    t.string "mg_c_city"
    t.string "mg_c_state"
    t.integer "mg_c_pin_code"
    t.string "mg_c_country"
    t.string "mg_p_address_line1"
    t.string "mg_p_address_line2"
    t.string "mg_p_street"
    t.string "mg_p_landmark"
    t.string "mg_p_city"
    t.string "mg_p_state"
    t.integer "mg_p_pin_code"
    t.string "mg_p_country"
    t.bigint "phone_number"
    t.bigint "mobile_number"
    t.string "mg_email_id"
    t.integer "amount"
    t.string "school_name"
    t.integer "marks_obtained"
    t.integer "total_marks"
    t.boolean "has_paid"
    t.integer "mg_user_id"
    t.boolean "hall_ticket_release"
    t.string "guardian_name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.float "selection_index"
    t.integer "exam_total_marks"
    t.float "obtained_marks"
    t.integer "student_temporary_id"
    t.float "previous_education_weightage"
    t.float "entrance_exam_weightage"
    t.integer "mg_batch_id"
    t.integer "mg_student_category_id"
    t.integer "mg_entrance_exam_details_id"
    t.string "admission_number"
    t.string "guardian_first_name"
    t.string "guardian_middle_name"
    t.string "guardian_last_name"
    t.string "relation"
    t.string "mother_first_name"
    t.string "mother_middle_name"
    t.string "mother_last_name"
    t.string "category"
    t.date "admission_date"
    t.string "f_qualification"
    t.string "f_occupation"
    t.string "f_designation"
    t.string "f_place_of_occupation"
    t.string "f_contact_no"
    t.string "f_email"
    t.string "m_qualification"
    t.string "m_occupation"
    t.string "m_designation"
    t.string "m_place_of_occupation"
    t.string "m_contact_no"
    t.string "m_email"
    t.float "family_annual_income"
    t.string "form_no"
    t.boolean "is_f_m_student_of_this_institution"
    t.string "height"
    t.string "father_office_address"
    t.string "father_whatsapp_number"
    t.string "nature_of_family"
    t.string "emergency_contact_details"
    t.string "emergency_contact_name"
    t.string "mother_tongue"
  end

  create_table "mg_student_appear_exams", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_question_set_id"
    t.integer "mg_student_id"
    t.integer "mg_school_id"
    t.datetime "start_time", precision: nil
    t.datetime "end_time", precision: nil
    t.boolean "is_complete"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_question_set_id", "mg_student_id", "is_deleted"], name: "idx_exam_appear_check", unique: true
    t.index ["mg_question_set_id"], name: "index_mg_student_appear_exams_on_mg_question_set_id"
    t.index ["mg_school_id"], name: "index_mg_student_appear_exams_on_mg_school_id"
    t.index ["mg_student_id"], name: "index_mg_student_appear_exams_on_mg_student_id"
  end

  create_table "mg_student_attandances", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_id"
    t.integer "mg_subject_id"
    t.boolean "is_absent"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_school_id", "mg_student_id"], name: "mg_school_id_2"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_student_attendances", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_id"
    t.integer "mg_period_table_entry_id"
    t.integer "mg_class_timing_id"
    t.boolean "is_halfday"
    t.boolean "is_afternoon"
    t.string "reason"
    t.date "absent_date"
    t.integer "mg_batch_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "no_of_back_days"
    t.index ["mg_school_id", "mg_batch_id"], name: "mg_school_id_2"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_student_batch_histories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_id"
    t.integer "from_class_id"
    t.integer "from_section_id"
    t.integer "to_class_id"
    t.integer "to_section_id"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "from_academic_year"
    t.string "to_academic_year"
    t.index ["mg_school_id"], name: "mg_school_id"
    t.index ["mg_student_id", "mg_school_id"], name: "mg_student_id"
  end

  create_table "mg_student_batch_history_bkps", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_school_id"
    t.integer "mg_student_id"
    t.boolean "is_deleted"
    t.integer "from_class_id"
    t.integer "from_section_id"
    t.integer "to_class_id"
    t.integer "to_section_id"
    t.string "from_academic_year"
    t.string "to_academic_year"
    t.integer "created_by"
    t.integer "updated_by"
    t.string "record_status"
    t.integer "mg_batch_history_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_student_categories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_student_exam_check_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_exam_check_id"
    t.integer "mg_question_bank_id"
    t.float "obtained_mark"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_question_bank_id"], name: "index_mg_student_exam_check_details_on_mg_question_bank_id"
    t.index ["mg_school_id"], name: "index_mg_student_exam_check_details_on_mg_school_id"
    t.index ["mg_student_exam_check_id", "mg_question_bank_id"], name: "idx_exam_check_bank", unique: true
    t.index ["mg_student_exam_check_id"], name: "index_mg_student_exam_check_details_on_mg_student_exam_check_id"
  end

  create_table "mg_student_exam_checks", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_id"
    t.integer "mg_create_question_paper_id"
    t.integer "mg_question_set_id"
    t.float "total_mark"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_batch_rank"
    t.integer "mg_class_rank"
    t.index ["mg_create_question_paper_id"], name: "index_mg_student_exam_checks_on_mg_create_question_paper_id"
    t.index ["mg_question_set_id"], name: "index_mg_student_exam_checks_on_mg_question_set_id"
    t.index ["mg_school_id"], name: "index_mg_student_exam_checks_on_mg_school_id"
    t.index ["mg_student_id"], name: "index_mg_student_exam_checks_on_mg_student_id"
  end

  create_table "mg_student_exam_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_appear_exam_id"
    t.integer "mg_question_bank_id"
    t.text "answer", collation: "utf8_general_ci"
    t.integer "mg_question_detail_id"
    t.integer "mg_question_type_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_question_bank_id"], name: "index_mg_student_exam_details_on_mg_question_bank_id"
    t.index ["mg_school_id"], name: "index_mg_student_exam_details_on_mg_school_id"
    t.index ["mg_student_appear_exam_id", "mg_question_bank_id"], name: "idx_exam_bank", unique: true
    t.index ["mg_student_appear_exam_id"], name: "index_mg_student_exam_details_on_mg_student_appear_exam_id"
  end

  create_table "mg_student_guardians", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_id"
    t.integer "mg_guardians_id"
    t.string "relation"
    t.boolean "has_login_access"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "primary_contact"
    t.index ["mg_school_id"], name: "mg_school_id"
    t.index ["mg_student_id", "mg_school_id"], name: "mg_student_id"
  end

  create_table "mg_student_hobbies", id: :integer, charset: "latin1", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_student_hostel_application_forms", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_id"
    t.integer "mg_guardian_id"
    t.integer "mg_course_id"
    t.integer "mg_batch_id"
    t.string "admission_number"
    t.date "date_of_application"
    t.string "mobile_no"
    t.string "email_id"
    t.text "contact_address"
    t.string "status"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_hostel_details_id"
    t.string "rejected_by"
    t.string "reason"
  end

  create_table "mg_student_id_cards", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "fields_name"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_student_item_consumptions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_id"
    t.integer "mg_course_id"
    t.integer "mg_batch_id"
    t.integer "mg_item_consumption_id"
    t.string "consumption_type"
    t.integer "mg_item_id"
    t.string "quantity_consumption"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_student_remarks_entries", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "remarks"
    t.string "result"
    t.boolean "is_submitted"
    t.string "mg_exam_attendance_id"
    t.string "attendance"
    t.string "created_by"
    t.string "updated_by"
    t.boolean "is_deleted"
    t.integer "mg_time_table_id"
    t.integer "mg_student_id"
    t.integer "mg_batch_id"
    t.integer "mg_school_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "periodic_test_1"
    t.string "periodic_test_2"
    t.string "periodic_test_3"
    t.string "periodic_test_4"
    t.string "periodic_test_5"
    t.string "term_1"
    t.string "term_2"
    t.string "remarks1"
    t.string "term_3"
    t.string "remarks3"
    t.index ["mg_school_id", "mg_student_id"], name: "mg_school_id_2"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_student_report_cards", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_id"
    t.integer "mg_time_table_id"
    t.integer "mg_course_id"
    t.integer "mg_batch_id"
    t.integer "mg_cbsc_exam_type_id"
    t.text "report_details"
    t.text "rank_details"
    t.string "total_marks"
    t.string "max_marks"
    t.string "rank"
    t.string "percentage"
    t.string "remark_one"
    t.string "remark_two"
    t.string "remark_three"
    t.string "remark_four"
    t.string "attendance_one"
    t.string "attendance_two"
    t.string "attendance_three"
    t.string "attendance_four"
    t.string "attendance_five"
    t.string "result"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "rank_total_marks"
    t.string "rank_max_marks"
    t.string "final_grade"
    t.string "subjects"
    t.string "subject_two"
  end

  create_table "mg_student_scholarships", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_user_id"
    t.string "name"
    t.string "amount"
    t.string "frequency"
    t.date "start_date"
    t.date "end_date"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_student_siblings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_admission_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.string "name"
    t.string "class_section"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_school_id"], name: "index_mg_student_siblings_on_mg_school_id"
    t.index ["mg_student_admission_id"], name: "index_mg_student_siblings_on_mg_student_admission_id"
  end

  create_table "mg_student_sub_answers", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_exam_detail_id"
    t.integer "mg_sub_question_bank_id"
    t.integer "mg_question_detail_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_school_id"], name: "index_mg_student_sub_answers_on_mg_school_id"
    t.index ["mg_student_exam_detail_id"], name: "index_mg_student_sub_answers_on_mg_student_exam_detail_id"
  end

  create_table "mg_student_subject_associations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_subject_id"
    t.integer "mg_batch_id"
    t.integer "mg_student_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_school_id", "mg_batch_id"], name: "mg_school_id_2"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_students", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "admission_number"
    t.string "nationality"
    t.text "extra_curricular"
    t.text "health_record"
    t.text "class_record"
    t.text "hobby"
    t.text "sport_activity"
    t.string "class_roll_number"
    t.date "admission_date"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.integer "mg_batch_id"
    t.integer "mg_course_id"
    t.date "date_of_birth"
    t.string "gender"
    t.string "blood_group"
    t.string "birth_place"
    t.integer "mg_nationality_id"
    t.string "language"
    t.string "religion"
    t.integer "mg_student_catagory_id"
    t.boolean "is_sms_enable"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at", precision: nil
    t.string "status_description"
    t.boolean "is_active"
    t.boolean "has_paid_fees"
    t.integer "mg_user_id"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_student_admission_id"
    t.string "adharnumber"
    t.integer "mg_caste_id"
    t.integer "mg_caste_category_id"
    t.boolean "is_archive"
    t.integer "mg_house_details_id"
    t.string "roll_number"
    t.date "archive_date"
    t.integer "mg_archive_reason_id"
    t.string "fee_code"
    t.string "pen_number"
    t.string "height"
    t.index ["mg_school_id"], name: "mg_school_id"
  end

  create_table "mg_sub_answer_checks", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_student_exam_check_detail_id"
    t.integer "mg_sub_question_bank_id"
    t.float "obtained_marks"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_school_id"], name: "index_mg_sub_answer_checks_on_mg_school_id"
    t.index ["mg_student_exam_check_detail_id"], name: "index_mg_sub_answer_checks_on_mg_student_exam_check_detail_id"
    t.index ["mg_sub_question_bank_id"], name: "index_mg_sub_answer_checks_on_mg_sub_question_bank_id"
  end

  create_table "mg_sub_question_banks", id: :integer, charset: "latin1", force: :cascade do |t|
    t.text "question_name", collation: "utf8_general_ci"
    t.integer "mg_question_bank_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.float "assign_mark"
    t.integer "difficulty_level"
    t.integer "blooms_level"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_question_bank_id"], name: "index_mg_sub_question_banks_on_mg_question_bank_id"
    t.index ["mg_school_id"], name: "index_mg_sub_question_banks_on_mg_school_id"
  end

  create_table "mg_subject_components", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_school_id"
    t.integer "mg_time_table_id"
    t.integer "mg_course_id"
    t.integer "mg_batch_id"
    t.integer "mg_subject_id"
    t.string "subject_component_name"
    t.boolean "is_deleted", default: false
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "scoring_type"
    t.index ["mg_batch_id"], name: "index_mg_subject_components_on_mg_batch_id"
    t.index ["mg_course_id"], name: "index_mg_subject_components_on_mg_course_id"
    t.index ["mg_school_id"], name: "index_mg_subject_components_on_mg_school_id"
    t.index ["mg_subject_id"], name: "index_mg_subject_components_on_mg_subject_id"
    t.index ["mg_time_table_id"], name: "index_mg_subject_components_on_mg_time_table_id"
  end

  create_table "mg_subjects", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_course_id"
    t.string "subject_name"
    t.string "subject_code"
    t.integer "max_weekly_class"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "is_core"
    t.boolean "is_lab"
    t.integer "no_of_classes"
    t.boolean "is_extra_curricular"
    t.boolean "is_archive"
    t.integer "index"
    t.string "scoring_type"
    t.string "display_name"
  end

  create_table "mg_syllabus_trackers", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_employee_id"
    t.integer "mg_syllabus_id"
    t.integer "mg_unit_id"
    t.integer "mg_topic_id"
    t.date "date"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "expected_class"
    t.integer "mg_batch_id"
  end

  create_table "mg_syllabuses", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_subject_id"
    t.string "name"
    t.text "description", collation: "utf8_general_ci"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_batch_id"
  end

  create_table "mg_time_table_change_entries", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_time_table_entry_id"
    t.integer "mg_batch_id"
    t.integer "mg_class_timing_id"
    t.integer "mg_timetable_id"
    t.integer "mg_subject_id"
    t.integer "mg_employee_id"
    t.date "date"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "is_permanent"
    t.integer "old_mg_employee_id"
    t.integer "old_mg_batch_id"
    t.integer "old_mg_subject_id"
    t.boolean "is_subject_replace"
    t.integer "replaced_mg_batch_id"
    t.integer "mg_wing_id"
  end

  create_table "mg_time_table_entries", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_batch_id"
    t.integer "mg_weekday_id"
    t.integer "mg_class_timings_id"
    t.integer "mg_subject_id"
    t.integer "mg_employee_id"
    t.integer "mg_timetable_id"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_time_tables", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_topics", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_unit_id"
    t.integer "mg_syllabus_id"
    t.text "topic_name", collation: "utf8_general_ci"
    t.text "description", collation: "utf8_general_ci"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_transfer_certificates", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "school_no"
    t.string "book_no"
    t.string "sr_no"
    t.string "admission_no"
    t.string "affiliation_no"
    t.string "reward_upto"
    t.string "school_status"
    t.string "reg_class"
    t.string "class_to"
    t.string "student_user"
    t.string "student_name"
    t.string "mother_name"
    t.string "father_name"
    t.string "nationality"
    t.string "caste"
    t.string "date_of_birth"
    t.string "student_status"
    t.string "subject"
    t.string "last_class"
    t.string "passed_class"
    t.string "next_class"
    t.string "w_paid"
    t.string "w_recipt"
    t.string "w_ncc"
    t.string "last_day"
    t.string "reason"
    t.string "no_days"
    t.string "no_days_attend"
    t.string "general"
    t.string "school_type"
    t.string "remarks"
    t.string "date_of_issue"
    t.integer "mg_school_id"
    t.integer "mg_student_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "student_performance"
    t.string "joining_date"
    t.string "games"
    t.integer "count"
  end

  create_table "mg_transport_time_managements", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_transport_id"
    t.string "bus_stop_name"
    t.time "pick_up_time"
    t.time "drop_time"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_transports", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "route_name"
    t.text "description"
    t.integer "mg_vehicle_id"
    t.integer "mg_employee_id"
    t.time "drop_start_time"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_employee_category_id"
    t.integer "mg_employee_position_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_units", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_syllabus_id"
    t.text "unit_name", collation: "utf8_general_ci"
    t.text "description", collation: "utf8_general_ci"
    t.integer "hour"
    t.integer "min"
    t.integer "time"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_user_albums", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_album_id"
    t.integer "mg_batch_id"
    t.integer "mg_employee_department_id"
    t.boolean "accessable_to_employees"
    t.boolean "accessable_to_students"
    t.boolean "accessable_to_guardians"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "accessable_teacher"
  end

  create_table "mg_user_otp_codes", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_user_id"
    t.string "otp_secret_key"
    t.datetime "expiry_date", precision: nil
    t.string "status"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "current_otp"
    t.string "module_name"
  end

  create_table "mg_user_questions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.text "question"
    t.text "answer"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "mg_user_id"
    t.string "user_type"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_user_roles", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_user_id"
    t.integer "mg_role_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_user_id", "mg_role_id"], name: "index_mg_user_roles_on_mg_user_id_and_mg_role_id"
  end

  create_table "mg_users", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "user_name"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "email"
    t.string "hashed_password"
    t.string "salt"
    t.string "reset_password_code"
    t.datetime "reset_password_code_until", precision: nil
    t.string "user_type"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_student_admission_id"
    t.integer "mg_specialization_id"
    t.boolean "is_reset_password"
    t.string "reset_password"
    t.boolean "need_to_reset_password"
    t.index ["mg_school_id"], name: "mg_school_id"
    t.index ["user_name"], name: "user_name"
  end

  create_table "mg_vaccination_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_vaccination_id"
    t.integer "mg_student_id"
    t.integer "mg_batch_id"
    t.integer "mg_time_table_id"
    t.date "due_date"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "name"
    t.string "age_recommended"
    t.boolean "is_particular_student"
    t.date "date"
  end

  create_table "mg_vaccinations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "age_recommended"
    t.text "description"
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_vehicles", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "vehicle_number"
    t.string "make"
    t.string "model"
    t.date "date_of_purchase"
    t.integer "no_of_seats"
    t.date "Current_insurance_due_date"
    t.date "last_service_date"
    t.date "next_service_date"
    t.boolean "is_under_repair"
    t.date "repair_completion_date"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.float "last_insurance_amount"
    t.string "vehicle_status"
    t.integer "mg_transport_id"
    t.integer "mg_employee_id"
    t.time "drop_start_time"
    t.integer "mg_employee_position_id"
    t.integer "mg_employee_category_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_video_configurations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "mg_weekdays", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_batch_id"
    t.integer "mg_wing_id"
    t.string "weekday"
    t.string "name"
    t.integer "sort_order"
    t.integer "day_of_week"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["mg_school_id", "mg_wing_id"], name: "mg_school_id"
  end

  create_table "mg_wings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "wing_name"
    t.boolean "status"
    t.boolean "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "online_important_infos", id: :integer, charset: "latin1", force: :cascade do |t|
    t.text "information"
    t.integer "mg_school_id"
    t.string "assigned_to"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "refresh_tokens", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "crypted_token"
    t.integer "user_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["crypted_token"], name: "index_refresh_tokens_on_crypted_token", unique: true
    t.index ["user_id"], name: "index_refresh_tokens_on_user_id"
  end

  create_table "roles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "role_name", limit: 20
    t.string "role_display_name", limit: 50
    t.text "description"
    t.string "status", limit: 20
    t.string "seeded", limit: 1
    t.integer "mg_school_id"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "sms_configurations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "vendor_name"
    t.string "url"
    t.string "msg_attribute"
    t.string "unicode_key"
    t.string "unicode_value"
    t.string "request_type"
    t.string "sender_id"
    t.string "sender_id_value"
    t.string "mobile_number_attribute"
    t.string "english_key"
    t.string "english_value"
    t.boolean "support_multiple_sms", default: false
    t.integer "max_sms_support"
    t.integer "mg_school_id"
    t.boolean "is_deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sms_temps", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "action_id"
    t.text "message"
    t.integer "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "mg_module_id"
    t.string "module_name"
    t.string "pe_id"
    t.string "template_id"
    t.string "vendor_name"
    t.string "activity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "student_measurements", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "mg_time_table_id"
    t.integer "mg_school_id"
    t.integer "mg_course_id"
    t.integer "mg_batch_id"
    t.integer "mg_student_id"
    t.integer "mg_cbsc_exam_type_id"
    t.string "height"
    t.string "weight"
    t.boolean "is_deleted"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "templates", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "action_id"
    t.text "message", size: :long, collation: "utf8_general_ci"
    t.integer "is_deleted"
    t.integer "mg_school_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mg_module_id"
    t.string "pe_id"
    t.string "template_id"
    t.string "vendor_name"
  end

  create_table "whitelisted_tokens", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "jti"
    t.integer "user_id"
    t.string "user_type"
    t.datetime "exp", precision: nil
    t.datetime "iat", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["jti"], name: "index_whitelisted_tokens_on_jti", unique: true
    t.index ["user_id"], name: "index_whitelisted_tokens_on_user_id"
  end
end
