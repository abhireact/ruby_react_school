class MgNotification < ApplicationRecord
  belongs_to(:mg_school)

  def self.send_notification(from_user_id, to_user_id, subject, description, school_id, is_deleted, created_by, updated_by)
    notification = MgNotification.new({ from_user_id:, to_user_id:, subject:, description:, status: false, mg_school_id: school_id, is_deleted:, created_by:, updated_by: })
  end

  def self.send_email(from_email_id, to_email_id, subject, description, school_id)
    message = Message.new
    message.subject=subject
    message.description=description
    message.to_user_id=to_email_id
    message.from_user_id=from_email_id
    puts(from_email_id.inspect)
    puts(to_email_id.inspect)
    server_response = NotificationMailer.send_mail(message).deliver!
    event_mail = MgMailStatus.new({ status_code: server_response.status, email_addrs_to: to_email_id, mg_school_id: school_id, email_addrs_by: from_email_id, email_subject: subject, email_server_description: server_description(server_response.status) })
  end

  def self.server_description(code_s)
    case code_s.to_s
    when "0"
      "Email address is not correct"
    when "211"
      "A system status message."
    when "214"
      "A help message for a human reader follows."
    when "220"
      "SMTP Service ready."
    when "221"
      "Service closing."
    when "250"
      "Requested action taken and completed. The best message of them all."
    when "251"
      "The recipient is not local to the server, but the server will accept and forward the message."
    when "252"
      "The recipient cannot be VRFYed, but the server accepts the message and attempts delivery."
    when "354"
      "Start message input and end with . This indicates that the server is ready to accept the message itself (after you have told it who it is from and where you want to to go)."
    when "421"
      "The service is not available and the connection will be closed."
    when "450"
      "The requested command failed because the users mailbox was unavailable (for example because it was locked). Try again later."
    when "451"
      "The command has been aborted due to a server error. Not your fault. Maybe let the admin know."
    when "452"
      "The command has been aborted because the server has insufficient system storage."
    when "500"
      "The server could not recognize the command due to a syntax error. "
    when "501"
      "A syntax error was encountered in command arguments."
    when "502"
      "This command is not implemented."
    when "503"
      "The server has encountered a bad sequence of commands."
    when "504"
      "A command parameter is not implemented."
    when "550"
      "The requested command failed because the users mailbox was unavailable (for example because it was not found, or because the command was rejected for policy reasons)."
    when "551"
      "The recipient is not local to the server. The server then gives a forward address to try."
    when "552"
      "The action was aborted due to exceeded storage allocation."
    when "553"
      "The command was aborted because the mailbox name is invalid."
    when "554"
      "The transaction failed. Blame it on the weather."
    end
  end

  def self.send_sms(mobile_number, text_msg, school_id, count)
    current_date = Date.today
    response_msg = ""
    if mobile_number.present?
      message = text_msg.to_s
      msg = message.gsub(" ", "%20")
      msg = msg.gsub("&", "%26")
      msg = msg.gsub("\r", "%2C")
      msg = msg.gsub("\n", "%0a")
      msg = msg.gsub("'", "%27")
      msg = msg.gsub("\"", "%22")
      phone_no_array = mobile_number
      puts("--------------------------------1")
      puts(phone_no_array.inspect)
      puts(" meassge ")
      puts(msg)
      puts("user messages ")
      require("open-uri")
      @sms_config = MgSmsConfigeration.where({ is_deleted: 0, mg_school_id: school_id })
      if @sms_config.present?
        @saveattr = MgSmsAddionAttribute.where({ mg_sms_configuration_id: @sms_config.[](0).id, is_deleted: 0, mg_school_id: school_id })
        @q = @saveattr.[](0).key + "=" + @saveattr.[](0).value
        if @saveattr.length > 0
          for i in 1..@saveattr.length - 1 do
            @q = "#{@q}" + "&" + @saveattr.[](i).key + "=" + @saveattr.[](i).value
          end
        end
      end
      if @sms_config.[](0).present?
        @url_exp = "#{@sms_config.[](0).url}" + "#{@q}" + "&" + "#{@sms_config.[](0).msg_attribute}" + "=" + "#{msg}" + "&" + "#{@sms_config.[](0).mobile_number_attribute}" + "=" + "#{phone_no_array}"
        base_url = @url_exp
      else
        @url_exp = "http://10.0.20.177/blank/sms/user/urlsmstemp.php?username=kapbulk&pass=kapbulk@@12345&senderid=KAPMSG&message=#{msg}&dest_mobileno=#{phone_no_array}&response=Y"
        base_url = "http://123.63.33.43/blank/sms"
      end
      puts(@url_exp)
      puts("===================================================")
      puts(@url_exp)
      response_msg += response
      hit = MgPageHitCount.find_or_create_by({ url: base_url, date: current_date, mg_school_id: school_id })
      count_increment = hit.update({ count: (hit.count.to_i + count) })
      puts("response")
      puts("response_msg")
      puts(response_msg)
      puts(@url_exp)
      response_msg
    end
  end

  def self.standard_message(user_name)
    message = ""
    message += "Hi " + user_name.to_s + "," + "\n" + "Wish You Happy Birthday" + " " + user_name.to_s
    message
  end

  def self.save_mg_sms_detail(from_user_id, to_user_id, from_module, message, school_id, response, mobile_number, user_name, msg_count)
    current_date = Date.today
    sms_detail = MgSmsDetail.new
    sms_detail.from_user_id=from_user_id
    sms_detail.to_user_id=to_user_id
    sms_detail.from_module=from_module
    sms_detail.message=message
    sms_detail.date=current_date
    sms_detail.is_deleted=0
    sms_detail.mg_school_id=school_id
    sms_detail.created_by=from_user_id
    sms_detail.updated_by=from_user_id
    sms_detail.response=response
    sms_detail.mobile_number=mobile_number
    sms_detail.user_name=user_name
    sms_detail.msg_count=msg_count
    sms_detail.save
  end

  def self.save_mg_sms_request(from_user_id, sms_type, message, school_id, status, receiver_type, receiver_id, template_id, pe_id)
    current_date = Date.today
    sms_request = MgSmsRequest.new
    sms_request.from_user_id=from_user_id
    sms_request.sms_type=sms_type
    sms_request.message=message
    sms_request.status=status
    sms_request.receiver_type=receiver_type
    sms_request.receiver_id=receiver_id
    sms_request.date=current_date
    sms_request.is_deleted=0
    sms_request.mg_school_id=school_id
    sms_request.created_by=from_user_id
    sms_request.updated_by=from_user_id
    sms_request.template_id=template_id
    sms_request.pe_id=pe_id
    sms_request
  end

  def self.save_mg_sms_requests(from_user_id, sms_type, message, school_id, status, receiver_type, receiver_id, template_id, pe_id)
    current_date = Date.today
    sms_request = MgSmsRequest.create({ from_user_id:, sms_type:, message:, status:, receiver_type:, receiver_id:, date: current_date, is_deleted: 0, mg_school_id: school_id, created_by: from_user_id, updated_by: from_user_id, template_id:, pe_id: })
  end

  def self.save_mg_sms_details(sms_request_id, receiver_obj, from_user_id, school_id, message, mobile_number, status, from_module)
    current_date = Date.today
    sms_detail = MgSmsDetail.new
    sms_detail.mg_sms_request_id=sms_request_id
    sms_detail.user_name=receiver_obj.user_full_name
    sms_detail.to_user_id=receiver_obj.id
    sms_detail.from_user_id=from_user_id
    sms_detail.date=current_date
    sms_detail.status=status
    sms_detail.message=message
    sms_detail.mobile_number=mobile_number
    sms_detail.from_module=from_module
    sms_detail.is_deleted=0
    sms_detail.mg_school_id=school_id
    sms_detail.created_by=from_user_id
    sms_detail.updated_by=from_user_id
    sms_detail.save
  end

  def self.sms_count_message(mg_school_id, count)
    current_date = Date.today
    year = current_date.year.to_s
    month = "%.2i" % current_date.month.to_s
    @sms_count = MgSmsCountSettings.where({ is_deleted: 0, mg_school_id: })
    if @sms_count.present?
      @check = (@sms_count.[](0).start_date_active..@sms_count.[](0).end_date_active).include?(current_date)
    end
    puts("hai date verify")
    puts(@check)
    puts("hai date verify")
    if @sms_count.[](0).present?
      query = "SELECT * FROM mg_sms_count_month_wises WHERE month like '" + year + "-" + month + "%' and mg_school_id=#{mg_school_id} and mg_sms_count_settings_id=#{@sms_count.[](0).id} "
    end
    if @check
      @sms_month = MgSmsCountMonthWise.find_by_sql(query)
      @sms_month.each { |sms_month_wise,|
        if sms_month_wise.present?
          if count.present?
            @total_sms = sms_month_wise.total_sms
            @available_sms = sms_month_wise.available_sms - count
            @count_of_sms_used = sms_month_wise.count_of_sms_used + count
            @exceed_count = 0
            if @available_sms < @count_of_sms_used
              @exceed = "yes"
              @exceed_count = @count_of_sms_used - @available_sms
              @cost_per_sms = @exceed_count * @sms_count.[](0).cost
            else
              @left_sms = @available_sms - @count_of_sms_used
            end
            sms_month_wise.update({ available_sms: @available_sms, count_of_sms_used: @count_of_sms_used, exceeded_sms_count: @exceed_count, exceeded_sms_cost: @cost_per_sms, mg_school_id: })
          else
            @total_sms = sms_month_wise.total_sms
            @available_sms = sms_month_wise.available_sms
            @count_of_sms_used = sms_month_wise.count_of_sms_used
            @exceed_count = 0
            if @available_sms > count_of_sms_used
              @exceed_count = sms_month_wise.exceeded_sms_count
            end
          end
        end
      }
    end
  end

  def self.send_inque_sms
    require("erb")
    include(ERB::Util)
    puts("RUNNING SCHEDULER")
    sms_requests = MgSmsRequest.where({ is_deleted: 0, status: "In Queue" })
    puts("================================================================")
    puts("#{sms_requests.count} messages are in queue.")
    puts("================================================================")
    request_arr = []
    sms_requests.each { |request,|
      static_msg = false
      school_name = MgSchool.where({ id: request.mg_school_id }).pluck(:school_name)
      request.update({ status: "Processing" })
      msg_is_dynamic = request.message.include?("$Child_name") || request.message.include?("$User_name") || request.message.include?("$Current_date") || request.message.include?("$Class_section")
      if !msg_is_dynamic
        static_msg = true
      end
      if "selected".casecmp(request.sms_type) == 0
        sms_obj_arr = []
        phone_no_array = []
        update_sql = ""
        request.mg_sms_details.each { |sms_obj,|
          mobile_number = sms_obj.mobile_number
          text_msg = sms_obj.message
          school_id = sms_obj.mg_school_id
          len = text_msg.length
          if (1..160).include?(len)
            count_of_msg = 1
          else
            if (161..306).include?(len)
              count_of_msg = 2
            else
              if (307..459).include?(len)
                count_of_msg = 3
              else
                if (460..612).include?(len)
                  count_of_msg = 4
                else
                  if (613..765).include?(len)
                    count_of_msg = 5
                  else
                    if (766..918).include?(len)
                      count_of_msg = 6
                    else
                      if (919..1000).include?(len)
                        count_of_msg = 7
                      end
                    end
                  end
                end
              end
            end
          end
          current_date = Date.today
          response_msg = ""
          if mobile_number.present?
            message = text_msg.to_s
            message = URI.encode(message)
            phone_no_array << mobile_number
            sms_obj_arr << sms_obj.id
            if static_msg
              if sms_obj == request.mg_sms_details.last
                response = get_sms_response(school_id, phone_no_array, message)
                if sms_obj_arr.present?
                  update_sql = "update mg_sms_details set response = '#{response.[](0)}', status = 'sent' where id in (#{sms_obj_arr.join(",")})"
                  ActiveRecord::Base.connection.execute(update_sql)
                end
              end
            else
              response = get_sms_response(school_id, mobile_number, message)
              if "failed".casecmp(response.[](0)) == 0
                sms_obj.update_attributes({ response: response.[](0), status: "Failed..We will try after some time!!" })
              else
                sms_obj.update_attributes({ response: response.[](0), status: "sent" })
              end
            end
          end
        }
        request.update({ status: "Sent" })
      else
        if "bulk".casecmp(request.sms_type) == 0
          update_sql = ""
          sms_message = request.message
          user_type = request.receiver_type
          school_id = request.mg_school_id
          from_user_id = request.from_user_id
          school = MgSchool.find_by({ id: school_id })
          if "Parent".casecmp(user_type.to_s) == 0 || "guardian".casecmp(user_type.to_s) == 0
            students = MgStudent.where({ is_deleted: 0, mg_school_id: school_id, mg_batch_id: request.receiver_id, is_archive: 0 }).pluck(:id)
            selected_users = MgGuardian.where({ is_deleted: 0, mg_school_id: school_id, mg_student_id: students }).pluck(:mg_user_id)
            batch = MgBatch.find_by({ mg_school_id: school.id, id: request.receiver_id })
            course = MgCourse.find_by({ mg_school_id: school.id, id: batch.mg_course_id }).course_name
            class_sec = "#{course}" "-" "#{batch.name}"
            sms_message = sms_message.gsub("$Class_section", class_sec)
          else
            if "Student".casecmp(user_type.to_s) == 0
              selected_users = MgStudent.where({ is_deleted: 0, mg_school_id: school_id, mg_batch_id: request.receiver_id, is_archive: 0 }).pluck(:mg_user_id)
            else
              if "Employee".casecmp(user_type.to_s) == 0 || "Teacher".casecmp(user_type.to_s) == 0
                selected_users = MgEmployee.where({ is_deleted: 0, mg_school_id: school_id, mg_employee_department_id: request.receiver_id }).pluck(:mg_user_id)
              end
            end
          end
          if selected_users.empty?
            next
          end
          is_msg_dynamic = false
          has_child_name = false
          current_date = Time.now.strftime("%d/%m/%y")
          if sms_message.include?("$Child_name") || sms_message.include?("$User_name")
            is_msg_dynamic = true
          end
          if sms_message.include?("$Child_name")
            has_child_name = true
          end
          sms_message = sms_message.gsub("$Current_date", current_date)
          sms_message = sms_message.gsub("$School_name", school.school_name)
          raw_sql = get_sql(user_type, is_msg_dynamic, has_child_name, school_id, selected_users)
          sms_message = URI.encode(sms_message)
          recepients = ActiveRecord::Base.connection.execute(raw_sql)
          recepients_sms_details = []
          phone_no_array = []
          response_for_all = ""
          recepients.to_a.each { |curr_recepient,|
            message = ""
            response = ""
            sms_detail = get_sms_detail_obj(user_type, curr_recepient, from_user_id, school_id, sms_message, request, has_child_name)
            phone_no_array << sms_detail.mobile_number
            message << sms_detail.message
            if static_msg
              if curr_recepient == recepients.to_a.last
                response_for_all = get_sms_response(school_id, phone_no_array, message)
              end
            else
              phone_no = [sms_detail.mobile_number]
              response = get_sms_response(school_id, phone_no, message)
            end
            if response.[](0).present?
              if "failed".casecmp(response.[](0)) == 0
                sms_detail.status="Failed..We will try after some time!!"
              end
            end
            if response.present?
              sms_detail.response=response.[](0)
            end
            recepients_sms_details << sms_detail
          }
          if response_for_all.present?
            recepients_sms_details.each { |curr_obj,|
              curr_obj.response=response_for_all.[](0)
            }
          end
          columns_without_id = MgSmsDetail.column_names.reject { |column,|
            column == "id"
          }
          save_sms_detail_saved = MgSmsDetail.import(columns_without_id, recepients_sms_details)
          request_arr << request.id
        end
      end
    }
    if request_arr.present?
      update_sql = "update mg_sms_requests set status = 'Sent' where id in (#{request_arr.join(",")})"
      ActiveRecord::Base.connection.execute(update_sql)
    end
    puts("SCHEDULER COMPLETED")
  end

  def self.get_sms_response(school_id, phone_no_array, msg)
    require("open-uri")
    priority_count = 0
    sms_config = MgSmsConfigeration.where({ is_deleted: 0, mg_school_id: school_id })
    key_value_pairs = ""
    url_exp = ""
    school_url = ""
    base_url = ""
    response = ""
    if sms_config.present?
      saveattr = MgSmsAddionAttribute.where({ mg_sms_configuration_id: sms_config.[](0).id, is_deleted: 0, mg_school_id: school_id })
      key_value_pairs = saveattr.[](0).key + "=" + saveattr.[](0).value
      if saveattr.length > 0
        for i in 1..saveattr.length - 1 do
          key_value_pairs = "#{key_value_pairs}" + "&" + saveattr.[](i).key + "=" + saveattr.[](i).value
        end
      end
      school_url = "#{sms_config.[](0).url}" + "?" + "#{key_value_pairs}" + "&" + "#{sms_config.[](0).msg_attribute}" + "=" + "#{msg}" + "&" + "#{sms_config.[](0).mobile_number_attribute}" + "=" + "#{phone_no_array.map(&:to_i)}" + "&" + "#{sms_config.[](0).sender_id}" + "=" + "#{sms_config.[](0).sender_id_value}"
      base_url = sms_config.[](0).url
    else
      url_exp = get_url_by_priority(school_id, phone_no_array, msg, priority_count)
    end
    require("timeout")
    if school_url.present?
      begin
        status = Timeout.timeout(5) {
        }
      rescue Timeout::Error
        response = "failed"
      end
    else
      begin
        if url_exp.[](0).present?
          status = Timeout.timeout(5) {
            base_url = url_exp.[](1)
            puts("###################################################################")
            puts(url_exp.[](0))
            puts("###################################################################")
          }
        end
      rescue Timeout::Error
        priority_count += 1
        url_exp = get_url_by_priority(school_id, phone_no_array, msg, priority_count)
        retry
      end
    end
    return response, base_url
  end

  def self.get_url_by_priority(school_id, phone_no_array, msg, priority_count)
    url_exp = ""
    msg = URI.encode(msg)
    priority_objs = MgSmsPriority.where({ is_deleted: 0 }).order(:priority)
    if priority_count <= priority_objs.size.-(1)
      sms_config = MgSmsConfigeration.where({ is_deleted: 0, id: priority_objs.[](priority_count).mg_sms_configeration_id })
      if sms_config.present?
        saveattr = MgSmsAddionAttribute.where({ mg_sms_configuration_id: sms_config.[](0).id, is_deleted: 0, mg_school_id: school_id })
        if saveattr.present?
          key_value_pairs = saveattr.[](0).key + "=" + saveattr.[](0).value
        end
        if saveattr.length > 0
          for i in 1..saveattr.length - 1 do
            key_value_pairs = "#{key_value_pairs}" + "&" + saveattr.[](i).key + "=" + saveattr.[](i).value
          end
        end
        url_exp = "#{sms_config.[](0).url}" + "?" + "#{key_value_pairs}" + "&" + "#{sms_config.[](0).msg_attribute}" + "=" + "#{msg}" + "&" + "#{sms_config.[](0).mobile_number_attribute}" + "=" + "#{phone_no_array.map(&:to_i)}" + "&" + "#{sms_config.[](0).sender_id}" + "=" + "#{priority_objs.[](priority_count).sender_id_value}"
        base_url = sms_config.[](0).url
      else
        url_exp = "http://10.0.20.177/blank/sms/user/urlsmstemp.php?username=kapbulk&pass=kapbulk@@12345&senderid=KAPMSG&message=#{msg}&dest_mobileno=#{phone_no_array}&response=Y"
        base_url = "http://123.63.33.43/blank/sms"
      end
    end
    return url_exp, base_url
  end

  def self.get_sql(user_type, is_msg_dynamic, has_child_name, school_id, selected_users)
    raw_sql = ""
    if "Parent".casecmp(user_type.to_s) == 0
      if is_msg_dynamic && has_child_name
        raw_sql = "select g.id, g.first_name, g.middle_name, g.last_name, p.phone_number, s.first_name, s.middle_name, s.last_name from mg_guardians g, mg_phones p, mg_students s where g.mg_school_id=#{school_id} and g.mg_user_id = p.mg_user_id and p.phone_type = 'mobile' and g.mg_user_id in (#{selected_users.join(",")}) and s.id = g.mg_student_id and s.is_deleted = 0 and s.is_archive = 0"
      else
        raw_sql = "select g.id, g.first_name, g.middle_name, g.last_name, p.phone_number from mg_guardians g, mg_phones p where g.mg_school_id=#{school_id} and g.mg_user_id = p.mg_user_id and p.phone_type = 'mobile' and g.mg_user_id in (#{selected_users.join(",")})"
      end
    else
      if "Student".casecmp(user_type.to_s) == 0
        raw_sql = "select s.id, s.first_name, s.middle_name, s.last_name, p.phone_number from mg_phones p, mg_students s where s.mg_school_id=#{school_id} and s.mg_user_id in (#{selected_users.join(",")}) and s.is_deleted = 0 and s.is_archive = 0 and s.mg_user_id = p.mg_user_id and p.phone_type = 'mobile'"
      else
        if "Teacher".casecmp(user_type.to_s) == 0 || "Employee".casecmp(user_type.to_s) == 0
          raw_sql = "select e.id, e.first_name, e.middle_name, e.last_name, p.phone_number from mg_phones p, mg_employees e where e.mg_school_id=#{school_id} and e.mg_user_id in (#{selected_users.join(",")}) and e.is_deleted = 0 and e.is_archive = 0 and e.mg_user_id = p.mg_user_id and p.phone_type = 'mobile'"
        end
      end
    end
    raw_sql
  end

  def self.get_sms_detail_obj(user_type, curr_recepient, logged_in_user_id, logged_in_school_id, sms_message, save_sms_request_obj, has_child_name)
    current_date = Date.today
    full_name = ""
    curr_message = ""
    to_user_id = ""
    mobile_number = ""
    message = ""
    if "Parent".casecmp(user_type.to_s) == 0
      full_name = curr_recepient.[](1).to_s + " " + curr_recepient.[](2).to_s + " " + curr_recepient.[](3).to_s
      full_name = full_name.gsub("-", " ").gsub("  ", "")
      curr_message = sms_message.gsub("$User_name", full_name)
      if has_child_name
        student_name = curr_recepient.[](5).to_s + " " + curr_recepient.[](6).to_s + " " + curr_recepient.[](7).to_s
        student_name = student_name.gsub("-", " ").gsub("  ", "")
        curr_message = curr_message.gsub("$Child_name", student_name)
      end
      to_user_id = curr_recepient.[](0)
      mobile_number = curr_recepient.[](4)
      message = curr_message
    else
      if "Student".casecmp(user_type.to_s) == 0
        full_name = curr_recepient.[](1).to_s + " " + curr_recepient.[](2).to_s + " " + curr_recepient.[](3).to_s
        full_name = full_name.gsub("-", " ").gsub("  ", "")
        curr_message = sms_message.gsub("$User_name", full_name)
        if has_child_name
          curr_message = curr_message.gsub("$Child_name", full_name)
        end
        to_user_id = curr_recepient.[](0)
        mobile_number = curr_recepient.[](4)
        message = curr_message
      else
        if "Teacher".casecmp(user_type.to_s) == 0 || "Employee".casecmp(user_type.to_s) == 0
          full_name = curr_recepient.[](1).to_s + " " + curr_recepient.[](2).to_s + " " + curr_recepient.[](3).to_s
          full_name = full_name.gsub("-", " ").gsub("  ", "")
          curr_message = sms_message.gsub("$User_name", full_name)
          if has_child_name
            curr_message = curr_message.gsub("$Child_name", full_name)
          end
          to_user_id = curr_recepient.[](0)
          mobile_number = curr_recepient.[](4)
          message = curr_message
        end
      end
    end
    verified = validation_of_phone_number(mobile_number)
    if !verified.[](0)
      mobile_number = verified.[](1)
    end
    msg_count = get_msg_count(message)
    sms_detail = MgSmsDetail.new
    sms_detail.mg_sms_request_id=save_sms_request_obj.id
    sms_detail.user_name=full_name
    sms_detail.to_user_id=to_user_id
    sms_detail.from_user_id=logged_in_user_id
    sms_detail.date=current_date
    sms_detail.response=""
    sms_detail.status="sent"
    sms_detail.mobile_number=mobile_number
    sms_detail.from_module="Notification"
    sms_detail.is_deleted=0
    sms_detail.mg_school_id=logged_in_school_id
    sms_detail.created_by=logged_in_user_id
    sms_detail.updated_by=logged_in_user_id
    sms_detail.message=message
    sms_detail.msg_count=msg_count
    sms_detail
  end

  def self.get_sms_detail_object(user_type, curr_recepient, logged_in_user_id, logged_in_school_id, sms_message, save_sms_request_obj, has_child_name)
    current_date = Date.today
    full_name = ""
    curr_message = ""
    to_user_id = ""
    mobile_number = ""
    message = ""
    if "Parent".casecmp(user_type.to_s) == 0
      full_name = curr_recepient.[](1).to_s + " " + curr_recepient.[](2).to_s + " " + curr_recepient.[](3).to_s
      full_name = full_name.gsub("-", " ").gsub("  ", "")
      curr_message = sms_message.gsub("$User_name", full_name)
      if has_child_name
        student_name = curr_recepient.[](5).to_s + " " + curr_recepient.[](6).to_s + " " + curr_recepient.[](7).to_s
        student_name = student_name.gsub("-", " ").gsub("  ", "")
        curr_message = curr_message.gsub("$Child_name", student_name)
      end
      to_user_id = curr_recepient.[](0)
      mobile_number = curr_recepient.[](4)
      message = curr_message
    else
      if "Student".casecmp(user_type.to_s) == 0
        full_name = curr_recepient.[](1).to_s + " " + curr_recepient.[](2).to_s + " " + curr_recepient.[](3).to_s
        full_name = full_name.gsub("-", " ").gsub("  ", "")
        curr_message = sms_message.gsub("$User_name", full_name)
        if has_child_name
          curr_message = curr_message.gsub("$Child_name", full_name)
        end
        to_user_id = curr_recepient.[](0)
        mobile_number = curr_recepient.[](4)
        message = curr_message
      else
        if "Teacher".casecmp(user_type.to_s) == 0 || "Employee".casecmp(user_type.to_s) == 0
          full_name = curr_recepient.[](1).to_s + " " + curr_recepient.[](2).to_s + " " + curr_recepient.[](3).to_s
          full_name = full_name.gsub("-", " ").gsub("  ", "")
          curr_message = sms_message.gsub("$User_name", full_name)
          if has_child_name
            curr_message = curr_message.gsub("$Child_name", full_name)
          end
          to_user_id = curr_recepient.[](0)
          mobile_number = curr_recepient.[](4)
          message = curr_message
        end
      end
    end
    verified = validation_of_phone_number(mobile_number)
    if !verified.[](0)
      mobile_number = verified.[](1)
    end
    msg_count = get_msg_count(message)
    sms_detail = MgSmsDetail.create({ mg_sms_request_id: save_sms_request_obj.id, user_name: full_name, to_user_id:, from_user_id: logged_in_user_id, date: current_date, response: "", status: "sent", mobile_number:, from_module: "Notification", is_deleted: 0, mg_school_id: logged_in_school_id, created_by: logged_in_user_id, updated_by: logged_in_user_id, message:, msg_count: })
    sms_detail
  end

  def self.validation_of_phone_number(number)
    if number.to_s.length == 10
      @output = "Verify"
      return true, @output
    else
      @output = "InValid Number"
      return false, @output
    end
  end

  def self.get_msg_count_old(text_msg)
    len = text_msg.length
    if (1..160).include?(len)
      count_of_msg = 1
    else
      if (161..306).include?(len)
        count_of_msg = 2
      else
        if (307..459).include?(len)
          count_of_msg = 3
        else
          if (460..612).include?(len)
            count_of_msg = 4
          else
            if (613..765).include?(len)
              count_of_msg = 5
            else
              if (766..918).include?(len)
                count_of_msg = 6
              else
                if (919..1000).include?(len)
                  count_of_msg = 7
                end
              end
            end
          end
        end
      end
    end
    count_of_msg
  end

  def self.get_msg_count(text_msg)
    require("cld")
    string_language = CLD.detect_language(text_msg)
    is_english = if string_language.[](:name) == "ENGLISH"
      true
    else
      false
    end
    if is_english
      len = text_msg.length
      if (1..160).include?(len)
        count_of_msg = 1
      else
        if (161..306).include?(len)
          count_of_msg = 2
        else
          if (307..459).include?(len)
            count_of_msg = 3
          else
            if (460..612).include?(len)
              count_of_msg = 4
            else
              if (613..765).include?(len)
                count_of_msg = 5
              else
                if (766..918).include?(len)
                  count_of_msg = 6
                else
                  if (919..1000).include?(len)
                    count_of_msg = 7
                  end
                end
              end
            end
          end
        end
      end
    else
      len = text_msg.length
      if (1..70).include?(len)
        count_of_msg = 1
      else
        count_of_msg = (len.to_f / 67.to_f).ceil
      end
    end
    count_of_msg
  end

  def self.check_fields(selected_users, descri, params, logged_in_school_id, list)
    unless descri.present? || params.[](:message).present?
      list << "Enter message"
    end
    if selected_users == nil && params.[](:Group) != "All"
      list << "Please select receviers"
    end
  end

  def self.check_sms_status(sms_details_array, requestobj)
    if requestobj.present?
      result_hash = {}
      sms_request = requestobj
      total_sms = []
      sms_details_array.select { |obj,|
        if obj.mg_sms_request_id == requestobj.id
          total_sms << obj
        end
      }
      if total_sms.present?
        sent_sms_arr = []
        total_sms.select { |obj,|
          if "sent".casecmp(obj.status) == 0
            sent_sms_arr << obj
          end
        }
        sent_sms = sent_sms_arr.length
        status_in_number = sent_sms.to_f / total_sms.length.to_f
        result_hash.[]=("total_sms", total_sms.length)
        result_hash.[]=("sent_sms", sent_sms)
        result_hash.[]=("status_percentage", status_in_number)
      else
        result_hash.[]=("total_sms", 0)
        result_hash.[]=("sent_sms", 0)
        result_hash.[]=("status_percentage", 0)
      end
      result_hash.[]=("status_value", sms_request.status)
    end
    result_hash
  end
end
