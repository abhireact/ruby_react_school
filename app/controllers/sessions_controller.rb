# version 1.1(25/04/2018 for session time out given @mamtha )
# version 1.2(16/10/2018 for attendance incharge login @mamtha )
# version 1.3(29/10/2018 for session time out error @mamtha )
# version 1.4 for School management incharge login 12/11/2018 by mamatha)

class SessionsController < ApplicationController
  #   before_filter :login_required
  # protect_from_forgery with: :exception
  # protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
   session[:user_type] = ''

    school_name = request.subdomain
    # school_name="sxiclu"
    if school_name.present?
      school_name = school_name[0...school_name.index('.')]
      @school = MgSchool.find_by(is_deleted: 0, subdomain: school_name)

      if @school.present? && @school.school_status != 'permanently_blocked'
        puts "SESSIONS DATA #{@school.id}"
        session[:current_user_school_id] = @school.id
      else
        permanent_blocking
      end
    else
      permanent_blocking
    end
  end

  def permanent_blocking
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/permanent_blocking_msg", layout: false, status: '404' }
      # format.xml  { head :not_found }
      # format.any  { head :not_found }
    end
  end

  def new
  end

  def dashboard
    logger.info '--dashboard--'
    logger.info @ModelData.model_name
  end

  def create
    puts 'I am herre.............'

    puts params[:user_name]
    puts 'I am till herre.............'
    # deleted= MgUser.where(:user_name=>params[:user_name]).pluck(:is_deleted)
    deleted = MgUser.where(user_name: params[:user_name], is_deleted: 0).pluck(:is_deleted)
    puts 'deleted'
    puts deleted
    puts "SchoolID----#{session[:current_user_school_id]}"

    school_status = MgSchool.find(session[:current_user_school_id])
    if school_status.school_status != 'temporarily_blocked'

      # user = MgUser.authenticateUsers(params[:user_name], params[:password], session[:current_user_school_id],deleted[0])
      # Added By Bindhu
      user = MgUser.authenticateUsersWithSchool(params[:user_name], params[:password], deleted[0],
                                                session[:current_user_school_id])
      if user.present?
        user_array = ['student', 'admin', 'employee', 'guardian', 'principal', 'school_admin', '', 'Teaching Staff',
                      'Non Teaching Staff', 'chairman']
        puts '============================'
        puts params[:user_type]
        puts '============================'
        if user_array.include? user.user_type
          @user_type = user.user_type
          if @user_type == 'employee'
            teaching_employees = MgEmployee.find_by(is_deleted: 0, mg_school_id: session[:current_user_school_id],
                                                    mg_user_id: user.id)
            teaching_employees = MgEmployeeCategory.find_by(is_deleted: 0,
                                                            id: teaching_employees.mg_employee_category_id)
            puts 'employeee_category'
            @user_type = teaching_employees.category_name
          end
          puts 'checkinggggggggg user_tyoeeeeeeeeeeeeeeeeeeee'
          puts @user_type
          puts 'checkinggggggggg user_tyoeeeeeeeeeeeeeeeeeeee'
          @login_access = if @user_type == params[:user_type]
                            1
                          else
                            0
                          end
        else
          @login_access = if params[:user_type] == 'functional incharge'
                            1
                          else
                            0
                          end
          puts 'other login'
        end
      end

      if user && @login_access == 1
        puts 'inside if   for cloud admin'

        # @school=MgSchool.find(1)
        @school = MgSchool.find(session[:current_user_school_id])

        ###########   start   for cloud admin ############
        if user.user_type.to_s.eql? 'cloudadmin'
          session[:current_user_school_id] = user.mg_school_id
          puts 'step >----------------->> 1 inside if condition'

          @user_type = user.user_type # MgUser.find(user.id)

          session[:user_type] = @user_type

          @sql = "SELECT P.id, P.mg_model_id, P.mg_action_id,  M.model_name
    FROM mg_permissions P,
    mg_users U,
    mg_user_roles UR,
    mg_roles R,
    mg_roles_permissions RP,
    mg_models M
    WHERE U.id = UR.mg_user_id
    AND U.mg_school_id=#{session[:current_user_school_id]}
    AND R.id = RP.mg_role_id
    AND RP.mg_permission_id = P.id
    AND P.mg_model_id = M.id
    AND U.id = #{user.id}
    AND RP.mg_school_id = #{user.mg_school_id}
    ORDER BY  M.index"
          # AND UR.mg_role_id = R.id
          @Pquery = MgPermission.find_by_sql(@sql)
          # puts "hjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj"
          # puts @Pquery.inspect

          # puts "hjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj"
          # puts bjjjjjjjjjjjjjjjjjjjjjj

          arrData = []
          arr = @Pquery

          puts 'Step -- 1 in login'
          puts arr.inspect
          # Iterating array
          arr.each do |a|
            # Generating hash
            roleData = {}
            roleData['model_id'] = a.mg_model_id
            roleData['action_id'] = a.mg_action_id
            roleData['model_name'] = a.model_name
            # Pushing in array
            arrData.push(roleData)
          end

          if arrData.length > 0
            # pushing in session our data array
            session[:roles_permissions_data] = arrData
            puts '-------------------------------------------------------------------'
            puts session[:roles_permissions_data].inspect
            puts '-------------------------------------------------------------------'

            $roles_permissions_data_global_var = arrData

            session[:user_id] = user.id

            # redirect_to :controller => 'dashboards/cloud_admin'
            # host=@school.subdomain<<"."<<"vcap.me"
            # redirect_to :host => host, :controller => 'dashboards', :action => 'cloud_admin'
            redirect_to controller: 'dashboards', action: 'cloud_admin'
            # redirect_to  url_for(:controller => "dashboards", :action => "cloud_admin",:subdomain => @school.subdomain)

          end
        # for bill incharge login
        elsif user.user_type.to_s.eql? 'bill_incharge'

          session[:current_user_school_id] = user.mg_school_id
          puts 'step >----------------->> 1 inside if condition'
          @user_type = user.user_type # MgUser.find(user.id)
          session[:user_type] = @user_type
          @sql = "SELECT P.id, P.mg_model_id, P.mg_action_id,  M.model_name
    FROM mg_permissions P,
    mg_users U,
    mg_user_roles UR,
    mg_roles R,
    mg_roles_permissions RP,
    mg_models M
    WHERE U.id = UR.mg_user_id
    AND U.mg_school_id=#{session[:current_user_school_id]}
    AND R.id = RP.mg_role_id
    AND RP.mg_permission_id = P.id
    AND P.mg_model_id = M.id
    AND U.id = #{user.id}
    AND RP.mg_school_id = #{user.mg_school_id}
    ORDER BY  M.index"
          @Pquery = MgPermission.find_by_sql(@sql)
          arrData = []
          arr = @Pquery
          puts 'Step -- 1 in login'
          puts arr.inspect
          arr.each do |a|
            roleData = {}
            roleData['model_id'] = a.mg_model_id
            roleData['action_id'] = a.mg_action_id
            roleData['model_name'] = a.model_name
            arrData.push(roleData)
          end

          if arrData.length > 0
            # pushing in session our data array
            session[:roles_permissions_data] = arrData
            puts '-------------------------------------------------------------------'
            puts session[:roles_permissions_data].inspect
            puts '-------------------------------------------------------------------'
            $roles_permissions_data_global_var = arrData
            session[:user_id] = user.id
            # redirect_to :controller => 'dashboards/cloud_admin'
            # host=@school.subdomain<<"."<<"vcap.me"
            # redirect_to :host => host, :controller => 'dashboards', :action => 'cloud_admin'

            redirect_to controller: 'mg_agents', action: 'bill_management'
            # redirect_to  url_for(:controller => "dashboards", :action => "cloud_admin",:subdomain => @school.subdomain)
          end
        else
          puts 'inside else for cloud admin'

          if !user.mg_school_id.nil?
            session[:current_user_school_id] = user.mg_school_id
            $current_user_school_id = user.mg_school_id
            ###########   end  for cloud admin ############

            @user_type = user.user_type # MgUser.find(user.id)
            session[:user_type] = @user_type
            # //pluck(:name)

            # @sql = "select A.id, A.mg_model_id, A.mg_action_id from mg_permissions A,mg_users B,mg_user_roles C, mg_roles D,mg_roles_permissions E Where B.id = C.mg_user_id AND C.mg_role_id = D.id AND D.id = E.mg_role_id AND E.mg_permission_id = A.id AND B.id = #{user.id} "

            @sql = "SELECT P.id, P.mg_model_id, P.mg_action_id ,M.model_name
      FROM mg_permissions P,
      mg_users U,
      mg_user_roles UR,
      mg_roles R,
      mg_roles_permissions RP,
      mg_models M
      WHERE U.id = UR.mg_user_id
      AND U.mg_school_id=#{session[:current_user_school_id]}
      AND UR.mg_role_id = R.id
      AND R.id = RP.mg_role_id
      AND RP.mg_permission_id = P.id
      AND P.mg_model_id = M.id
      AND U.id = #{user.id}
      AND RP.mg_school_id = #{user.mg_school_id}
      ORDER BY  M.index"

            # @sql = "select G.model_name, F.action_name,  A.id, A.model_id, A.action_id from permissions A,users B,user_roles C, roles D,roles_permissions E, actions F , models G Where B.id = C.user_id AND C.role_id = D.id AND D.id = E.role_id AND E.permission_id = A.id  AND A.action_id = F.id AND A.model_id = G.id AND B.id =#{@user.id}"

            @Pquery = MgPermission.find_by_sql(@sql)
            puts @Pquery.inspect
            # puts jhhhhhhhhhhhhhhhhhhh

            arrData = []
            arr = @Pquery

            puts 'Step -- 1 in login'

            puts arr.inspect
            # Iterating array
            arr.each do |a|
              # Generating hash
              roleData = {}
              roleData['model_id'] = a.mg_model_id
              roleData['action_id'] = a.mg_action_id
              roleData['model_name'] = a.model_name
              # Pushing in array
              arrData.push(roleData)
            end
            puts arrData.length
            puts 'Step -- 2 '
            # if User have Access to our model
            if arrData.length > 0
              # pushing in session our data array
              session[:roles_permissions_data] = arrData
              $roles_permissions_data_global_var = arrData
              session[:user_id] = user.id
              # render "dashboard"
              # Configuraing The email address starts Here
              # email_congig=MgEmailConfiguration.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
              # if email_congig.present?
              # set_mailer_settings(email_congig)
              # end
              # Configuraing The email address ends Here
              puts 'Step -- 1'
              puts @user_type
              puts '==============================='
              puts 'Step -- 1'

              if @user_type == 'guardian'
                # Added By Bindhu Start
                login_guardian = MgGuardian.where(mg_user_id: session[:user_id])
                login_access = MgStudentGuardian.where(mg_guardians_id: login_guardian[0].id, is_deleted: 0,
                                                       mg_school_id: session[:current_user_school_id])
                puts 'Login Guardian'
                puts login_guardian.inspect

                puts 'Login Access'
                puts login_access.inspect
                @tmp = 0
                login_access.each do |guardian|
                  next unless guardian.has_login_access

                  student_details = MgStudent.find_by(id: guardian.mg_student_id, is_deleted: 0,
                                                      mg_school_id: session[:current_user_school_id])
                  @tmp = 1 if student_details.is_archive == false
                end
                puts 'temp'
                puts @tmp

                if @tmp == 1
                  redirect_to controller: 'dashboards/guardian'
                else
                  flash[:notice] = "You doesn't have the login access please contact your admin"
                  redirect_to root_url
                end
              elsif @user_type == 'principal'
                redirect_to controller: 'dashboards/principal_updates'
              elsif (@user_type == 'school_incharge' || @user_type == 'AdmissionIncharge') && (session[:current_user_school_id] == 47 || session[:current_user_school_id] == 48)
                redirect_to controller: 'mg_student_admission_requests/custom_admission'
              elsif @user_type == 'school_incharge'
                puts "----------School ID--> #{session[:current_user_school_id]} ------------"
                puts "#----------You are logging into #{@user_type} ------------#"
                puts 'successfully Loggind in'
                redirect_to controller: 'dashboard', action: 'index'
              # redirect_to wings_path
              # redirect_to wings_path(format: :html)
              elsif @user_type == 'student'
                login_student = MgStudent.find_by(mg_user_id: session[:user_id], is_deleted: 0,
                                                  mg_school_id: session[:current_user_school_id])
                if login_student.is_archive == false
                  redirect_to controller: 'dashboards/student'
                else
                  flash[:notice] = "You doesn't have the login access please contact your admin"
                  redirect_to root_url
                end
              elsif @user_type == 'employee'
                redirect_to controller: 'dashboards/employee'
              elsif @user_type == 'kiosk'
                redirect_to controller: 'library/search_reserve_books_index'

              elsif @user_type == 'front_office_manager'
                redirect_to controller: 'front_office_management/user_detail'

              elsif @user_type == 'laboratory_incharge'
                redirect_to controller: '/laboratory/purchase/'
              elsif @user_type == 'laboratory_assistant_incharge'
                redirect_to controller: '/laboratory/consumption/'
              elsif @user_type == 'library_incharge'
                puts 'inside library_inchargelogin'
                redirect_to controller: 'library'
              elsif @user_type == 'library_assistant_incharge'
                redirect_to controller: '/dashboards/library_book_issue_index'
              # Bindhu Added for store_manager login starts
              elsif @user_type == 'store_manager'
                redirect_to controller: 'inventory/store_information'
              # Bindhu Added for store_manager login ends
              # Bindhu Added for Accounts login starts
              elsif @user_type == 'central_account_incharge'
                redirect_to controller: 'accounts/account_index'

              elsif @user_type == 'central_account_assistant_incharge'
                redirect_to controller: '/accounts/transfer'

              elsif @user_type == 'Alumni'
                # puts ajgsdfga
                redirect_to controller: '/alumni/alumni_login'
              elsif @user_type == 'account_incharge'
                redirect_to controller: '/accounts/accounts_review'
              # Bindhu Added for Accounts login starts
              # Added By Jitendra for finance manager login start
              elsif @user_type == 'financial_manager'
                redirect_to controller: 'inventory/proposal_review'
              # Added By Jitendra for finance manager login end
              elsif @user_type == 'cloudadmin'
                redirect_to controller: 'dashboards/cloud_admin'
              elsif @user_type == 'superprincipal'
                redirect_to controller: 'dashboards/principal'
              elsif @user_type == 'healthcare_admin'
                puts 'inside Health'
                redirect_to controller: 'healthcare'
              # Added By Bindhu for doctor login starts
              elsif @user_type == 'doctor'
                redirect_to controller: 'healthcare/health_test'
              # Added By Bindhu for doctor login ends
              elsif @user_type == 'sports_incharge'
                # puts ahsdjkad
                redirect_to controller: 'sports_management/game'
              elsif @user_type == 'hostel_admin'
                # puts ahsdjkad
                redirect_to controller: 'hostel_management/hostel_application_list'
              elsif @user_type == 'chairman'
                puts 'inside chairman'
                # redirect_to :controller => 'graph'
                redirect_to controller: 'dashboards/principal'
              elsif @user_type == 'attendance_incharge'
                redirect_to controller: 'attendances/attendances_incharge_page'
              elsif @user_type == 'homework_incharge'
                redirect_to controller: 'homework/homework_incharge_index'
              elsif @user_type == 'hostel_warden'
                redirect_to controller: 'hostel_management/room_type'
              elsif @user_type == 'canteen_manager'
                redirect_to controller: '/canteen_managements/meal_category'
              elsif @user_type == 'sub_admin'
                redirect_to controller: 'master_settings'
              elsif @user_type == 'admin'
                # redirect_to :controller => 'master_settings'
                redirect_to controller: 'dashboards/principal_updates'
              else
                session[:school_functional_incharge] = 'school_users'
                puts session[:roles_permissions_data].inspect
                modelName = MgModel.find(arrData[0]['model_id'])
                if modelName.model_name.downcase == 'laboratory'
                  redirect_to controller: '/laboratory/subject'
                elsif modelName.model_name.downcase == 'alumni'
                  redirect_to controller: '/alumni/alumni_registration_form'
                elsif modelName.model_name.downcase == 'canteen_managements'
                  redirect_to controller: '/canteen_managements'
                elsif modelName.model_name.downcase == 'curriculum'
                  redirect_to controller: '/curriculum/class_show'
                elsif modelName.model_name.downcase == 'front_office_management'
                  redirect_to controller: '/front_office_management/category'
                elsif modelName.model_name.downcase == 'online_assessment'
                  redirect_to controller: '/curriculum/class_show'
                elsif modelName.model_name.downcase == 'lms'
                  redirect_to controller: '/curriculum/class_show'
                elsif modelName.model_name.downcase == 'examination'
                  @school = MgSchool.find_by(is_deleted: 0, id: session[:current_user_school_id])
                  mark_user = MgUser.find(session[:user_id])
                  @gradingType = ['', 'CCE', 'GPA', 'CWE', 'CBSE']
                  if @gradingType[@school.grading_system.to_i] == 'CBSE'
                    if session[:current_user_school_id] == 71 && mark_user.user_type != 'MarksEntry'
                      redirect_to controller: '/cbsc_examinations/scholascti_exam_management_index'
                    else
                      redirect_to controller: '/cbsc_examinations/other_marksEntry'
                    end
                  else
                    redirect_to controller: '/examination'
                  end
                else
                  redirect_to controller: modelName.model_name.downcase # Deepak
                end

              end
            # else user don't have any permission
            else
              flash.now.alert = 'Please contact your admin for give you access to use website!'
              redirect_to root_url
            end

          # If school id not assigned redirect here
          else
            flash.now.alert = 'School is not assign to you. Please contact admin!'
            flash[:notice] = 'School is not assign to you. Please contact admin!'
            redirect_to root_url

          end
        end

      else

        if @login_access == 0
          flash.now.alert = 'User Name and User Type mismatch'
          flash[:notice] = 'User Name and User Type mismatch'
        else
          flash.now.alert = 'Invalid username or password'
          flash[:notice] = 'Invalid User Name or Password'
        end

        redirect_to root_url

      end

    else
      flash.now.alert = 'Sorry, The requested portal has been temporarily blocked by your website administrator.'
      flash[:notice] = 'Sorry, The requested portal has been temporarily blocked by your website administrator.'
      redirect_to root_url
    end
  end

  # Log out work in destroy action it would be delete session
  def destroy
    session[:user_id] = nil
    session[:roles_permissions_data] = nil
    session[:current_user_school_id] = nil
    session[:school_functional_incharge] = nil
    session.clear
    # reset_session
    puts 'Application is Logged out!!'
    redirect_to root_url, notice: 'Logged out!'
  end

  def forgot_password
    logger.info 'sessions_forgot_password step -- 11'

    user = MgUser.find_by(email: email_params[:email])

    if user
      session[:update_password_for_user_id] = user.id
      respond_to do |format|
        format.js {}
      end
    else
      render plain: params[:sessions].inspect
      # your email address is not valid
      render plain: email_params

    end
  end

  def update_password
    @user = MgUser.find(session[:update_password_for_user_id])

    return unless @user

    @user.update(password_params)
    respond_to do |format|
      format.js {}
    end
  end

  def change_school
    puts params[:principal][:mg_school_id]
    school = MgSchool.find(params[:principal][:mg_school_id])

    session[:current_user_school_id] = school.id

    # host=school.subdomain<<"."<<"vcap.me"
    # redirect_to :host => host, :controller => 'dashboards', :action => 'principal'
    redirect_to controller: 'dashboards', action: 'principal'
    # redirect_to :controller=>'dashboards', :action=>'principle'#, :subdomain=>'ksd'

    # redirect_to  url_for(:controller => "dashboards", :action => "principal",:subdomain => school.subdomain)

    # url_for(:controller => "da_controller",
    #   :action => "cool_feature",
    #   :subdomain => "admin")
    # redirect_to root_url(:host => "subdomain" + '.' + request.domain + request.port_string, :controller=>"principle")
  end

  def write_action
    controller_list = []
    Dir['app/controllers/*.rb'].each do |file|
      # controller_list.push({"#{file.split('/').last.sub!('_controller.rb','')}"=>"dd"})
      next unless file.split('/').last.sub!('_controller.rb', '').present?

      # controller_list.push({"#{file.split('/').last.sub!('_controller.rb','')}"=> file.split('/').last.sub!('.rb','').split('_').map(&:strip).map(&:capitalize).join('').constantize.action_methods.collect{|a| a.to_s}.join(', ')  })
      controller_list += file.split('/').last.sub!('.rb',
                                                   '').split('_').map(&:strip).map(&:capitalize).join('').constantize.action_methods.collect do |a|
        a.to_s
      end.join(',').split(',')
    end

    # str = "[80, 75, 3, 4, 10, 0, 0, 0, 0, 0, -74, 121, 57, 64, 0, 0, 0, 0]"
    #   int_array = str.gsub('[', '').gsub(']', '').split(', ').collect{|i| i.to_i}
    File.open(File.join(Rails.root, 'public', 'file.txt'), 'wb') do |file|
      file.write(controller_list.uniq.to_json.to_s)
    end
    puts "controller_list---------->   #{controller_list.size}"
    # controller_list.uniq.each do |s|
    #   MgAction.create(:action_name=>s)
    # end
  end

  def forgot_password_new
    render layout: false
  end

  def forgot_password_create
    if params[:user_id].present?
      user_obj = MgUser.where(user_name: params[:user_id], is_deleted: 0)
      if user_obj.id.present?
        mg_user_id = user_obj.id
        msg = 'New Password is abcdef, the new password will expire in 24 hours'
      end

    elsif params[:email_id].present?
      @email_from = MgEmail.find_by(mg_email_id: params[:email_id], is_deleted: 0)
      if @email_from.mg_user_id.present?
        mg_user_id = @email_from.mg_user_id
        msg = 'New Password is abcdef, the new password will expire in 24 hours'

      end
    end

    send_email_create(mg_user_id, msg)
  end

  def send_email_create(user, msg)
    # begin
    @email_from = MgEmail.where(mg_user_id: session[:user_id])
    @message = Message.new
    @message.subject = 'Forgot Password'
    @message.description = msg
    @email_to = MgEmail.where(mg_user_id: user)

    if @email_to.present?
      to_user_id = @email_to[0][:mg_email_id]
      from_user_id = if @email_from.present?
                       @email_from[0][:mg_email_id]
                     else
                       'jreddy@mindcomgroup.com'
                     end
      # server_response = NotificationMailer.send_mail(@message).deliver!
      # begin
      # notification=MgNotification.send_notification(session[:user_id],user,@message.subject,@message.description,session[:current_user_school_id],0,session[:user_id],session[:user_id])
      #  notification.save
      MgNotification.send_email(from_user_id, to_user_id, @message.subject, @message.description, 0)

      # rescue Exception => e
      # puts e
      # end
      # :email_server_description => server_description(server_response.status) )
    else
      puts 'Email id is not present'
    end
  end

  private

  def email_params
    params.require(:sessions).permit(:email)
  end

  def password_params
    params.require(:sessions).permit(:password)
  end
end
