#version 1.1(25/09/18/Mamatha FOR student sort based on admission number and user id) 
#version 1.2(25/09/18/Mamatha FOR student sort based on roll number) 
#version 1.3(25/09/18/Mamatha FOR binding.pry) 
#version 1.4(16/10/18/Mamatha FOR attendance_incharge) 
#version 1.5(29/10/18/Mamatha FOR student attendance in attendance_incharge login) 
#version 1.6(31/01/19/monalisa multiple student make as absent and present at a time) 
#version 1.7(26/02/19/ skipping break periods from marking absent, by jyoti prakash) 
#version 1.8(11/06/20/ pop up summary for marking absent, by Darshan) 


class AttendancesController < ApplicationController
   #com
 layout "mindcom"
  #  before_filter :login_required

 require 'date'
 require 'active_support/core_ext'
 
  def new
    puts "Step--new method 1"
   


      @batchId = params[:batchId]
       date_student_id = params[:date_student_id]
       month = params[:month]
       year = params[:year]
      logger.info(date_student_id.inspect)

      date_student_id=date_student_id.split(",")
      logger.info(date_student_id.inspect)
      date=date_student_id[0]
      @day=date
      @student_id=date_student_id[1]
      logger.info(date)
      logger.info(@student_id)
      @final_date=date+"-"+month+"-"+year
      logger.info(@final_date)



  render :layout => false

    
  end
  def attendances_incharge_page
  end

def server_description(code_s)
    
    case code_s.to_s

          when '0'
              return "Email address is not correct"
        
          when '211'   
              return "A system status message."
          when '214'   
              return "A help message for a human reader follows."
          when '220'   
              return "SMTP Service ready."
          when '221'   
              return "Service closing."
          when '250'   
              return "Requested action taken and completed. The best message of them all."
          when '251'   
              return "The recipient is not local to the server, but the server will accept and forward the message."
          when '252'   
              return "The recipient cannot be VRFYed, but the server accepts the message and attempts delivery."
          when '354'   
              return "Start message input and end with . This indicates that the server is ready to accept the message itself (after you have told it who it is from and where you want to to go)."



          when '421'   
              return "The service is not available and the connection will be closed."
          when '450'   
              return "The requested command failed because the users mailbox was unavailable (for example because it was locked). Try again later."
          when '451'   
              return "The command has been aborted due to a server error. Not your fault. Maybe let the admin know."
          when '452'   
              return "The command has been aborted because the server has insufficient system storage."


          when '500'   
              return "The server could not recognize the command due to a syntax error. "

          when '501'   
              return "A syntax error was encountered in command arguments."
          when '502'   
              return "This command is not implemented."
          when '503'   
              return "The server has encountered a bad sequence of commands."
          when '504'   
              return "A command parameter is not implemented."

          when '550'   
              return "The requested command failed because the users mailbox was unavailable (for example because it was not found, or because the command was rejected for policy reasons)."
          when '551'   
              return "The recipient is not local to the server. The server then gives a forward address to try."
          when '552'   
              return "The action was aborted due to exceeded storage allocation."
          when '553'   
              return "The command was aborted because the mailbox name is invalid."
          when '554'   
              return "The transaction failed. Blame it on the weather."
          
    end
   
  end
def index
      redirect_to :controller=>'employees_attendances',:action=>'index'
end

  def update
  @attendances = MgStudentAttendance.find(params[:id])
 
  @attendances.update(ajax_params)
  @attendances.updated_by=session[:user_id]
  @attendances.save

# redirect_to :action => "index"
end

def delete
  # subjects/delete/"+splString[1]
   @attendances=MgStudentAttendance.find_by_id(params[:id])

  @attendances.is_deleted =1
  @attendances.save
  
end

def edit
      @batchId = params[:batchId]
      date_student_id = params[:date_student_id]
      month = params[:month]
      year = params[:year]
      logger.info(date_student_id.inspect)

      date_student_id=date_student_id.split(",")
      logger.info(date_student_id.inspect)
      date=date_student_id[0]
      @day=date
      @student_id=date_student_id[1]
      logger.info(date)
      logger.info(@student_id)
      @final_date=(date+"-"+month+"-"+year).to_datetime
      logger.info(@final_date)
      id=MgStudentAttendance.where(:absent_date=>@final_date, :mg_student_id=>params[:id]).pluck(:id)
      puts "id ---- step --1"
      puts id[0]
      @attendances=MgStudentAttendance.find(id[0])
      puts "step  ------2----"
      puts @attendances.inspect
 render :layout => false


  
end

  #Added and Modified By Deepak Starts
def employee_holiday_attendance_new
  @action = "new"
  @holiday = MgEmployeeHolidayAttendances.new


  
end
def employee_holiday_attendance_create
 
  @timeformat = MgSchool.find(session[:current_user_school_id])
  date = Date.strptime(params[:day_of_presence_onchange],@timeformat.date_format)
  presentEmployees = params[:present_data]
  presentEmployee_id = Array.new
    if presentEmployees.present?
        presentEmployees.each do |id|
        presentEmployee_id.push(id.to_i)
        end
    end
  employeeArr = MgEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_category_id=>params[:mg_employee_category],:mg_employee_department_id=>params[:mg_employee_department_id]).pluck(:id)
  absentEmployee_id =(employeeArr - presentEmployee_id)  
# Code for Create MgEmployeeHolidayAttendances Starts
    if presentEmployee_id.present?
        presentEmployee_id.each do |emp_id|
          if MgEmployeeHolidayAttendances.find_by(:mg_holiday_id=>params[:mg_holiday_id],:mg_employee_id=>emp_id,:mg_employee_department_id=>params[:mg_employee_department_id],:is_present=>1,:mg_school_id=>session[:current_user_school_id],:is_deleted=>0,:day_of_presence=>date).present?
          else
          @holiday = MgEmployeeHolidayAttendances.new
          @holiday.mg_holiday_id = params[:mg_holiday_id]
          @holiday.mg_employee_id = emp_id
          @holiday.mg_employee_department_id = params[:mg_employee_department_id]
          @holiday.is_present =  true
          @holiday.is_deleted =  false
          @holiday.mg_school_id = session[:current_user_school_id]
          @holiday.created_by = session[:user_id]
          @holiday.updated_by = session[:user_id]
          @holiday.day_of_presence = date
         
           if @holiday.save
              @notice = "Attendance Saved/Updated successfully"
            else
              @notice = "Attendance is Not Saved/Updated"
            end
          end
        end
    end
# Code for Create MgEmployeeHolidayAttendances Ends
# Code for Update MgEmployeeHolidayAttendances Starts
    if absentEmployee_id.present?
        absentEmployee_id.each do |emp_id|
          @holiday = MgEmployeeHolidayAttendances.find_by(:mg_holiday_id=>params[:mg_holiday_id],:mg_employee_id=>emp_id,:mg_employee_department_id=>params[:mg_employee_department_id],:is_present=>1,:mg_school_id=>session[:current_user_school_id],:is_deleted=>0,:day_of_presence=>date)
          if @holiday.present?
            
            if @holiday.update(:is_deleted=>1,:is_present=>false)
            @notice = "Attendance Saved/Updated successfully"
            else
              @notice = "Attendance is Not Saved/Updated"
            end
          else 
          end
        end
    end
# Code for Update MgEmployeeHolidayAttendances Ends
flash[:notice] = @notice
    redirect_to :controller => 'attendances', :action =>'employee_holiday_attendance_new'
  end


def get_holiday_and_employee_department
    mg_employee_category_id = params[:mg_employee_category_id]
    holidayAll = MgHoliday.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:applicable_for=> "All").pluck(:holiday_name,:id)
    @holiday = view_context.get_holiday_by_emp_category(mg_employee_category_id)
    # MgHoliday.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_category_id=>mg_employee_category_id).pluck(:holiday_name,:id)
    # @employeeDepartment = MgEmployeeDepartment.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:department_name,:id)
    @employeeDepartment = view_context.get_employee_department
    holidayAll.each_with_index do |all,i|
      @holiday.insert(i,all)
    end

    render :layout => false
  
end

def get_employee_list
    @timeformat = MgSchool.find(session[:current_user_school_id])
    date = Date.strptime(params[:date],@timeformat.date_format)
    if params[:mg_employee_category_id].present?
      @employee = MgEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_category_id=>params[:mg_employee_category_id],:mg_employee_department_id=>params[:mg_employee_department_id])
    else
      @employee = MgEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_department_id=>params[:mg_employee_department_id])

    end
   @holiday_emp_list =  MgEmployeeHolidayAttendances.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_department_id=>params[:mg_employee_department_id],:mg_holiday_id=>params[:mg_holiday_id],:is_present=>1,:day_of_presence=>date).pluck(:mg_employee_id)
   render :layout => false
end
def getStartDateEndDate
  id = params[:mg_holiday_id]
  holiday = MgHoliday.find(id)
  startDate = holiday.holiday_start_date.to_s
  @startDate =startDate.split("-")

  endDate = holiday.holiday_end_date.to_s
  @endDate = endDate.split("-")
   render :layout => false
  

  
end



  def holiday_lists
    mg_school_id = session[:current_user_school_id]
    school=MgSchool.find(mg_school_id)
    @dateFormat = school.date_format
    # @mg_holiday = MgHoliday.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order(:holiday_start_date)
    if params[:mg_time_table_id]
      @mg_holiday = MgHoliday.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],mg_time_table_id:params[:mg_time_table_id]).order(:holiday_start_date)
      @timeTableId = params[:mg_time_table_id]
      respond_to do |format|
        format.js
        format.html
      end
    end

  end

  def holiday_new
    if params[:timeTabeleId].present?
      academicYear = MgTimeTable.find_by(is_deleted:0,mg_school_id:session[:current_user_school_id],id:params[:timeTabeleId])
      startDate = academicYear.start_date.strftime("%d/%m/%Y")
      endDate = academicYear.end_date.strftime("%d/%m/%Y")
      render :json=>{startDate:startDate, endDate:endDate}, :layout=>false
    end
    allArr = Array.new
    allArr.push("All","all")
    studentArr = Array.new
    studentArr.push("Student","student")
    @applicable = MgEmployeeCategory.where(:is_deleted=>0).pluck(:category_name,:id);
    @applicable.insert(0,allArr)
    @applicable.insert(1,studentArr)
  end

  def holiday_submit
    applicable = params[:applicable_for]
    params.inspect
    @mg_holiday = MgHoliday.new(holiday_params)
    @timeformat = MgSchool.find(session[:current_user_school_id])
    @holiday_start_date = Date.strptime(params[:holiday][:holiday_start_date],@timeformat.date_format)
    @holiday_end_date = Date.strptime(params[:holiday][:holiday_end_date],@timeformat.date_format)
    @mg_holiday.holiday_start_date = @holiday_start_date
    @mg_holiday.holiday_end_date = @holiday_end_date
    @mg_holiday.mg_time_table_id = params[:mg_time_table_id]
    if applicable =="all"
      @mg_holiday.applicable_for = "All"
    elsif applicable =="student"
      @mg_holiday.is_for_student = true
      @mg_holiday.applicable_for = "Student"
      
    else
       @mg_holiday.is_for_employee = true
       @mg_holiday.mg_employee_category_id = applicable
       empCategory = MgEmployeeCategory.find(applicable)
       @mg_holiday.applicable_for = empCategory.category_name      
    end

    if @mg_holiday.save
      flash[:notice] = "Holiday Created successfully"
    else
      flash[:error] = "Date is overlapping"
    end
    redirect_to :controller => 'attendances', :action =>'holiday_lists'
  end

  def holiday_detail  
    params.inspect
    mg_school_id=session[:current_user_school_id]
    school=MgSchool.find(mg_school_id)
    @dateFormat = school.date_format
    @mg_holiday = MgHoliday.find(params[:id])
  end

  def holiday_edit
    mg_school_id=session[:current_user_school_id]
    school=MgSchool.find(mg_school_id)
    @dateFormat = school.date_format
    @mg_holiday = MgHoliday.find(params[:id])
    if @mg_holiday.mg_time_table_id.present?
      academicYear = MgTimeTable.find_by(is_deleted:0,mg_school_id:session[:current_user_school_id],id:@mg_holiday.mg_time_table_id)
      @startDate = academicYear.start_date.strftime("%d/%m/%Y")
      @endDate = academicYear.end_date.strftime("%d/%m/%Y")
    end
    allArr = Array.new
    allArr.push("All","all")
    studentArr = Array.new
    studentArr.push("Student","student")
    @applicable = MgEmployeeCategory.where(:is_deleted=>0).pluck(:category_name,:id);
    @applicable.insert(0,allArr)
    @applicable.insert(1,studentArr)
  end

  def holiday_delete
    @mg_holiday = MgHoliday.find(params[:id])

    boolVal = MgDependancyClass.holiday_dependancy("mg_holiday_id",params[:id])
    if boolVal == true
      flash[:error] = "Cannot Delete this Wing is Having Dependencies"
    else
       @mg_holiday.update(:is_deleted=>1)
       flash[:notice] = "Deleted Successfully"
    end

    redirect_to :controller => 'attendances', :action =>'holiday_lists'
  end

  def holiday_update
    applicable = params[:applicable_for]
    puts params.inspect
    @mg_holiday = MgHoliday.find(params[:holiday][:id])
    @mg_holiday.holiday_name = params[:holiday][:holiday_name]
    @timeformat = MgSchool.find(session[:current_user_school_id])
    @holiday_start_date = Date.strptime(params[:holiday][:holiday_start_date],@timeformat.date_format)
    @holiday_end_date = Date.strptime(params[:holiday][:holiday_end_date],@timeformat.date_format)
    @mg_holiday.holiday_start_date = @holiday_start_date
    @mg_holiday.holiday_end_date = @holiday_end_date
    @mg_holiday.description = params[:holiday][:description]

    if applicable =="all"
      @mg_holiday.applicable_for = "All"
      @mg_holiday.is_for_student = nil
      @mg_holiday.is_for_employee = nil
      @mg_holiday.mg_employee_category_id = nil
    elsif applicable =="student"
      @mg_holiday.is_for_student = true
      @mg_holiday.applicable_for = "Student"
      @mg_holiday.is_for_employee = nil
      @mg_holiday.mg_employee_category_id = nil
    else
      @mg_holiday.is_for_student = nil
      @mg_holiday.is_for_employee = true
      @mg_holiday.mg_employee_category_id = applicable
      empCategory = MgEmployeeCategory.find(applicable)
      @mg_holiday.applicable_for = empCategory.category_name      
    end
    if @mg_holiday.save
      flash[:notice] = "Holiday updated successfully"
    else
      flash[:error] = "Date is overlapping"
    end
    redirect_to :controller => 'attendances', :action =>'holiday_lists'
  end

  def holidays_pdf

    time_table_for="all_class"
    mg_school_id=session[:current_user_school_id]
    school=MgSchool.find(mg_school_id)
    holidays = MgHoliday.where(:is_deleted=>0,:mg_school_id=>mg_school_id,:mg_time_table_id=>params[:mg_time_table_id]).order(:holiday_start_date)
    @@dateFormat = school.date_format
    # applicable = Array.new
    # holidays.each do |mg_holiday|
    #   if mg_holiday.is_for_student == true
    #     applicable.push("Students")
    #   elsif mg_holiday.is_for_employee == true && mg_holiday.mg_employee_category_id.present?
    #      employee_category = MgEmployeeCategory.find_by(:is_deleted=>0,:id=> mg_holiday.mg_employee_category_id)
    #      applicable.push(employee_category.category_name)
    #    else
    #     applicable.push("")
    #   end
    # end

    pdf = Prawn::Document.new(:page_layout => :landscape) do
      @@school_logo=school.logo.url(:medium,:timestamp=>false)
        repeat :all do
          # header
          bounding_box [bounds.left, bounds.top],:align => :right, :width  =>bounds.width  do
            font "Helvetica"
            if File.exists?("#{Rails.root}/public/#{@@school_logo}") 
              image( "#{Rails.root}/public/#{@@school_logo}",:width =>  45)
            end
            move_up 15
            text school.school_name, :align => :center, :size => 18
            stroke_horizontal_rule
          end
          # footer
          bounding_box [bounds.left, bounds.bottom + 5], :width  => bounds.width do
            font "Helvetica"
            stroke_horizontal_rule
            move_down(5)
            move_down 10
            draw_text "Powered By - ©", :at => [550,3]
            image "#{Rails.root}/app/assets/images/mindcom-logo.png", :at=>[645,15], :width => 45, :align => :right
          end
        move_up 480
        end


        text "Holiday Lists", :align => :center, :size => 18

        move_down 15

        widths = [125,125,125,125]
        cell_height = 10
        font_size=12
         widths_for=[140,140]

      table([["Holiday Name","Holiday Start Date","Holiday End Date","Applicable for"]],:column_widths => 145,:cell_style => { size: font_size },:position=>:center) 
      holidays.each_with_index do |holiday,i|
      table([["#{holiday.holiday_name}","#{holiday.holiday_start_date.strftime(@@dateFormat)}","#{holiday.holiday_end_date.strftime(@@dateFormat)}","#{holiday.applicable_for}"]],:column_widths => 145,:cell_style => { size: font_size },:position=>:center) 
      end
    end #pdf end
    # end
    send_data pdf.render,   :info => {
                        :CreationDate => Time.now
                        }, :filename => "holidays.pdf", :type => "application/pdf", :disposition => 'inline'
  end

  def studentsHash

    data = Array.new
    puts "StudentsHash -- is comming"
    @sql = "Select * from mg_students where mg_batch_id = #{params[:id]} and mg_school_id=#{session[:current_user_school_id]} and is_deleted=#{0} and is_archive = 0"
    @students = MgStudent.find_by_sql(@sql)
    data.push(@students)
    # @sql1 = "Select absent_date from mg_student_attendances where mg_batch_id = #{params[:id]} "
    @sql1 = "select DATE_FORMAT(absent_date, '%Y') year, DATE_FORMAT(absent_date, '%c') month, DATE_FORMAT(absent_date, '%e') day, mg_student_id from mg_student_attendances where mg_batch_id = #{params[:id]} and is_deleted=0 and mg_school_id=#{session[:current_user_school_id]} and is_archive = 0"

    @absent_dates = MgStudent.find_by_sql(@sql1)
    data.push(@absent_dates)



        respond_to do |format| 
            format.json  { render :json =>  data }
          

        end
  end
#Added and Modified By Deepak ends

def createstudent
  @all_data = params.require(:attendances).permit(:from_date, :to_date, :mg_student_id, :mg_batch_id, :reason, :is_halfday, :is_afternoon)
    
    start_dt=@all_data[:from_date]
    end_dt=@all_data[:to_date]
    total_days=(end_dt.to_date - start_dt.to_date).to_i
    total_days=total_days+1
    puts "xxxxxxxxxxxxxxxxxxxxxxxxxx"
    puts total_days

     for i in 0...total_days
                          date=@all_data[:from_date]
                          puts "absent_date"
                          puts date
                          arr = date.split('-');
                          # days = Time.days_in_month(arr[1].to_i+1, arr[2].to_i)
                          month= arr[1].to_i
                          year=arr[2].to_i
                          day =arr[0].to_i
                          puts "day"
                          puts day
                          puts "month"
                          puts month
                          puts "year"
                          puts year
                               abc= Date.new(year,month,day) + i
                               puts abc
                          savedate=abc.to_s

      sql="INSERT INTO mg_student_attendances(absent_date, mg_student_id, reason, is_halfday, is_afternoon, mg_batch_id, is_deleted, is_approved) VALUES ( '#{savedate}', #{@all_data[:mg_student_id]}, '#{@all_data[:reason]}', #{@all_data[:is_halfday]}, #{@all_data[:is_afternoon]}, #{@all_data[:mg_batch_id]})"
          ActiveRecord::Base.connection.execute(sql)  
        end


    redirect_to :controller => 'dashboards'
  
end

   def create
    @attendances=MgStudentAttendance.new(ajax_params)
    @no_of_days= params.permit(:no_of_days, :absent_date)
    no_of_days=@no_of_days[:no_of_days]
    no_of_days=no_of_days.to_i
    @date=params[:absent_date]
    @dateFormat=Date.parse(@date)
    @datevalue=@dateFormat.strftime('%d')
    puts "date="+@datevalue
    
     

    if(no_of_days != 0)
       @all_data= params.permit(:mg_student_id, :mg_period_table_entry_id, :is_afternoon, :is_halfday, :reason, :absent_date, :mg_batch_id ,:is_deleted)
           $dayCount=0
          $dayCheck= Date.new

      for i in 0...no_of_days
                date=@all_data[:absent_date]
                puts "absent_date"
                puts date
                arr = date.split('-');
                month= arr[1].to_i
                year=arr[2].to_i
                day =arr[0].to_i
                puts "day"
                puts day
                puts "month"
                puts month
                puts "year"
                puts year
                
                $dayCheck= Date.new(year,month,day)+$dayCount
                dayName=$dayCheck.strftime("%A")
                puts 'i try to get day name'
                puts dayName
                puts 'i got day name'

                  if dayName=='Sunday'

                    $dayCount +=1
                    $dayCheck= Date.new(year,month,day)+$dayCount
                    $dayCount +=1
                    puts "i am in if condition   ----if----"
                  else
                     $dayCheck= Date.new(year,month,day) + $dayCount
                     puts $dayCheck
                     $dayCount +=1
                    puts "i am in if condition   ----else----"

                     puts "step ----1-----"
                  end
                     puts $dayCheck.strftime("%A")
                     puts "step -----2------"
                savedate=$dayCheck.to_s
                # @student=MgStudentAttendance.new(:mg_student_id=>@all_data[:mg_student_id], :is_halfday, :is_afternoon,
                #  :reason, :absent_date, :mg_batch_id, :is_deleted, :mg_school_id, :created_by, :updated_by)
                @student=MgStudentAttendance.new(ajax_params)
                 @student.absent_date=savedate
                 @student.is_deleted=0
                 @student.mg_school_id=session[:current_user_school_id]
                 @student.created_by=session[:user_id]
                 @student.save

                # sql="INSERT INTO mg_student_attendances (mg_student_id, is_halfday, is_afternoon, reason, absent_date, mg_batch_id, is_deleted) VALUES (#{@all_data[:mg_student_id]}, #{@all_data[:is_halfday]}, #{@all_data[:is_afternoon]}, '#{@all_data[:reason]}', '#{savedate}', #{@all_data[:mg_batch_id]}, 0)"
                # # # sql="INSERT INTO mg_student_attendances(absent_date) VALUES('#{savedate}')"
                # ActiveRecord::Base.connection.execute(sql)    
      end  
    else
       @attendances.save
    end  
  end

  def student
    @userID=session[:user_id]
    puts "student_index ------ step 1"
    puts @userID

    @studentID= MgStudent.where(:mg_user_id => "#{@userID}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :is_archive=> 0).pluck(:id)
    puts "student_index ------ step 2"
    puts @studentID

    @batchID= MgStudent.where(:mg_user_id => "#{@userID}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :is_archive=> 0).pluck(:mg_batch_id) 
    puts "student_index ------ step 3"
    puts @batchID

                                    
    @batchName= MgBatch.where(:id => "#{@batchID}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:name) 
    puts "student_index ------ step 4"
    puts @batchName

   
  end


  def student_index
    @userID=session[:user_id]
    puts "student_index ------ step 1"
    puts @userID

    @studentID= MgStudent.where(:mg_user_id => "#{@userID}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :is_archive=> 0).pluck(:id)
    puts "student_index ------ step 2"
    puts @studentID

    @batchID= MgStudent.where(:id => "#{@studentID[0]}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :is_archive=> 0).pluck(:mg_batch_id) 
    puts "student_index ------ step 3"
    batchID=@batchID[0]
    puts @batchID[0]
    puts batchID

                                    
    @batchName= MgBatch.where(:id => "#{@batchID[0]}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:name) 
    puts "student_index ------ step 4"
    puts @batchName

    data = Array.new
    puts "student_index ------ step 5"

    @sql = "Select * from mg_students where mg_batch_id = #{batchID} and mg_students.id = #{@studentID[0]} and is_deleted=0 and mg_school_id=#{session[:current_user_school_id]} and is_archive = 0"
    @students = MgStudent.find_by_sql(@sql)
    data.push(@students)
    # @sql1 = "Select absent_date from mg_student_attendances where mg_batch_id = #{params[:id]} "
    @sql1 = "select DATE_FORMAT(absent_date, '%Y') year, DATE_FORMAT(absent_date, '%c') month, DATE_FORMAT(absent_date, '%e') day, mg_student_id from mg_student_attendances where mg_batch_id = #{batchID} and is_deleted=0 and mg_school_id=#{session[:current_user_school_id]}"

    @absent_dates = MgStudent.find_by_sql(@sql1)
    puts @absent_dates.inspect
    data.push(@absent_dates)
    holidays= "select DATE_FORMAT(holiday_start_date, '%Y') start_year, DATE_FORMAT(holiday_start_date, '%c') start_month, 
              DATE_FORMAT(holiday_start_date,'%e') start_day,
              DATE_FORMAT(holiday_end_date, '%Y') end_year, DATE_FORMAT(holiday_end_date, '%c') end_month,
              DATE_FORMAT(holiday_end_date,'%e') end_day from mg_holidays  where is_deleted = 0 and mg_school_id = #{session[:current_user_school_id] } 
              and ( is_for_student = 1 or applicable_for = 'Student' or applicable_for = 'All')"

    @holiday_dates = MgHoliday.find_by_sql(holidays)
     data.push(@holiday_dates)
        respond_to do |format| 
            format.json  { render :json =>  data }
        end
    
  end

  def view_attendance
    @userID=session[:user_id]
    puts "student_index ------ step 1"
    puts @userID

    @mg_student_id= MgGuardian.where(:mg_user_id => "#{@userID}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:mg_student_id)
    puts "student_index ------ step 22"
    puts @mg_student_id

    @studentID= MgStudent.where(:id => "#{@mg_student_id[0]}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :is_archive=> 0).pluck(:id)
    puts "student_index ------ step 2"
    puts @studentID

    @batchID= MgStudent.where(:id => "#{@mg_student_id[0]}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :is_archive=> 0).pluck(:mg_batch_id) 
    puts "student_index ------ step 3"
    puts @batchID

                                    
    @batchName= MgBatch.where(:id => "#{@batchID[0]}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:name) 
    puts "student_index ------ step 4"
    puts @batchName
 # render :layout => false

    
  end
  def gardian_index
    @userID=session[:user_id]
    puts "student_index ------ step 1"
    puts @userID

    @mg_student_id= MgGuardian.where(:mg_user_id => "#{@userID}", :mg_school_id=>session[:current_user_school_id], :is_deleted=>0).pluck(:mg_student_id)
    puts "student_index ------ step 22----- "
    puts @mg_student_id.inspect

     @studentID= MgStudent.where(:id => "#{@mg_student_id[0]}", :mg_school_id=>session[:current_user_school_id], :is_deleted=>0, :is_archive=> 0).pluck(:id)
    puts "student_index ------ step 2"
    puts @student_id

    @batchID= MgStudent.where(:id => "#{@mg_student_id[0]}", :mg_school_id=>session[:current_user_school_id], :is_deleted=>0, :is_archive=> 0).pluck(:mg_batch_id) 
    puts "student_index ------ step 3"
    batchID=@batchID[0]
    puts batchID

    @Guardian= MgGuardian.where(:mg_user_id => "#{@userID}", :mg_school_id=>session[:current_user_school_id], :is_deleted=>0).pluck(:id)

                                    
    @batchName= MgBatch.where(:id => "#{@batchID[0]}", :mg_school_id=>session[:current_user_school_id], :is_deleted=>0).pluck(:name) 
    puts "student_index ------ step 4"
    puts @batchName

    data = Array.new
    puts "student_index ------ step 5"

    # @sql = "Select * from mg_students where mg_batch_id = #{batchID} and mg_students.id = #{@studentID[0]} and mg_school_id=#{session[:current_user_school_id]} and is_deleted=0"
    # @students = MgStudent.find_by_sql(@sql)
    @sql = "SELECT S.first_name ,S.last_name,S.admission_number, S.id from mg_students S,mg_guardians G ,mg_student_guardians M Where M.has_login_access=1 And  M.mg_guardians_id  = #{@Guardian[0]} And S.id = M.mg_student_id and G.id = M.mg_guardians_id and S.is_deleted=0 and S.mg_school_id=#{session[:current_user_school_id]} and G.is_deleted=0 and G.mg_school_id=#{session[:current_user_school_id]} and M.is_deleted=0 and M.mg_school_id=#{session[:current_user_school_id]} and S.is_archive = 0"

    @students=MgStudent.find_by_sql(@sql)
    data.push(@students)
    # @sql1 = "Select absent_date from mg_student_attendances where mg_batch_id = #{params[:id]} "
    @sql1 = "select DATE_FORMAT(absent_date, '%Y') year, DATE_FORMAT(absent_date, '%c') month, DATE_FORMAT(absent_date, '%e') day, mg_student_id from mg_student_attendances where is_deleted=0 and mg_student_id= #{@studentID[0]} and mg_batch_id= #{@batchID[0]} and mg_school_id=#{session[:current_user_school_id]}"

    @absent_dates = MgStudent.find_by_sql(@sql1)
    puts @absent_dates.inspect
    data.push(@absent_dates)
     holidays= "select DATE_FORMAT(holiday_start_date, '%Y') start_year, DATE_FORMAT(holiday_start_date, '%c') start_month, 
                  DATE_FORMAT(holiday_start_date,'%e') start_day,
                  DATE_FORMAT(holiday_end_date, '%Y') end_year, DATE_FORMAT(holiday_end_date, '%c') end_month,
                  DATE_FORMAT(holiday_end_date,'%e') end_day from mg_holidays  where is_deleted = 0 and mg_school_id = #{session[:current_user_school_id] } 
                  and ( is_for_student = 1 or applicable_for = 'Student' or applicable_for = 'All')"

    @holiday_dates = MgHoliday.find_by_sql(holidays)
    data.push(@holiday_dates)

        respond_to do |format| 
            format.json  { render :json =>  data }
        end
    
  end
  def show
    @userID=session[:user_id]

    @stuID=MgGuardian.find_by_mg_user_id(@userID)
    @studentID=@stuID.mg_student_id
    
   
    #@studentID= MgStudent.where(:mg_user_id => "#{@userID}").pluck(:id)
     @batID=MgStudent.where(:mg_user_id => @userID, :mg_school_id=>session[:current_user_school_id], :is_deleted=>0, :is_archive=> 0).pluck(:mg_batch_id)

     puts @batID.inspect
     puts "step  ---1---"

     puts @batID
     puts "step ----2---"
    #  if @batID!=nil
    #   @batchID=@batID.mg_batch_id
    # else
    #   puts"else"
    #   @batchID=''
    # end  

   

  end
  def apply_leave

     # @all_data = params.require(:attendances).permit(:from_date, :to_date, :mg_student_id, :mg_batch_id, :reason, :is_halfday, :is_afternoon)
    @userID=session[:user_id]
     # @batID=MgStudent.where(:mg_user_id => @userID)
    @studentID=MgGuardian.find_by_mg_user_id(@userID)
    puts @studentID.mg_student_id
    @batID=MgStudent.where(:id=>@studentID.mg_student_id, :mg_school_id=>session[:current_user_school_id], :is_deleted=>0, :is_archive=> 0).pluck(:mg_batch_id)
    puts @batID[0]

    @student = MgStudent.find(params[:id])
   

   # render :layout => false


  end
   def apply_leave_for_student


   # jhfj
    # @student = MgStudent.find(params[:id])
    puts "apply_leave_for_student"
    # puts @student.inspect
   @timeformat = MgSchool.find(session[:current_user_school_id])
    # @half_day_date = Date.strptime(params[:mg_employee_leave_types][:half_day_date],@timeformat.date_format)

    @all_data = params.require(:attendances).permit(:mg_student_id, :is_afternoon, :is_halfday, :reason, :from_date, :to_date, :mg_batch_id ,:is_deleted)
    @student = MgStudent.where(:id=>@all_data[:mg_student_id], :is_archive=> 0)

    puts "step ----1----"
    @batID=MgStudent.where(:id=>params[:mg_student_id], :mg_school_id=>session[:current_user_school_id], :is_deleted=>0, :is_archive=> 0).pluck(:mg_batch_id)
    puts @batID[0]
    if params[:attendances][:from_date].present?
      @from_date = Date.strptime(params[:attendances][:from_date],@timeformat.date_format)
    end
    if params[:attendances][:to_date].present?
      @to_date = Date.strptime(params[:attendances][:to_date],@timeformat.date_format)
    end
     if params[:attendances][:date].present?
      @date = Date.strptime(params[:attendances][:date],@timeformat.date_format)
    end
    puts @from_date
    puts @to_date 
   leave_date = (@from_date..@to_date).map(&:to_s)
   holiday = MgHoliday.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:holiday_start_date,:holiday_end_date)
   holiday.each do |holiday_date|
   holiday_date = (holiday_date[0]..holiday_date[1]).map(&:to_s)
   leave_date = leave_date - holiday_date
 end
   puts leave_date.inspect
    # @from_date= @all_data[:from_date]
    # puts @from_date
    # @to_date= @all_data[:to_date]
    # puts @to_date


    # @from_date=@all_data[:from_date]
    # @to_date=@all_data[:to_date]
    @stud_array = []
    puts "xxxxxxxxxxxxxxxxxxxxxxxxxx"

    puts params[:attendances][:is_halfday]
    puts "xxxxxxxxxxxxxxxxxxxxxxxxxx"

    if params[:attendances][:is_halfday]=='false'
          total_days=(@to_date.to_date - @from_date.to_date).to_i
          total_days=total_days+1
          puts "xxxxxxxxxxxxxxxxxxxxxxxxxx"
          puts total_days

           for i in 0...leave_date.length
                                date=Date.parse(@from_date.to_s).strftime("%d-%m-%Y")
                                puts "absent_date"
                                puts date
                                arr = date.split('-');
                                # days = Time.days_in_month(arr[1].to_i+1, arr[2].to_i)
                                month= arr[1].to_i
                                year=arr[2].to_i
                                day =arr[0].to_i
                                puts "day"
                                puts day
                                puts "month"
                                puts month
                                puts "year"
                                puts year
                                     abc= Date.new(year,month,day) + i
                                     puts abc
                                savedate=abc.to_s
            puts @batID[0]
           attendance = MgStudentAttendance.find_by(:mg_student_id=>params[:attendances][:mg_student_id],:mg_batch_id=>params[:attendances][:mg_batch_id],:mg_school_id => session[:current_user_school_id],:is_deleted=>0,:absent_date=>leave_date[i])
           puts attendance.inspect
            if attendance.present?
              @stud_array.push(attendance.absent_date)
              puts "-------------------------------"
              puts "-------------------------------"
            else
            @attendances=MgStudentAttendance.new(attes_params)
            @attendances.absent_date=leave_date[i]
            @attendances.save
          end
              end
     else
        @attendances=MgStudentAttendance.new(attes_params)
        @attendances.absent_date=@date

        @attendances.save
     end
     puts @stud_array.inspect
     #=========================================================================================
     begin
       @guardian=MgGuardian.where(:mg_user_id => session[:user_id],:mg_school_id=>session[:current_user_school_id])
       @student_id=@guardian[0].mg_student_id
       @student_batch=MgStudent.where(:id=>@student_id, :is_archive=> 0).pluck(:mg_batch_id)
       @class_teacher_id=MgBatch.where(:id=>@student_batch[0]).pluck(:mg_employee_id)

       if  @class_teacher_id[0].present?
        puts "-------------------"
        puts @class_teacher_id
        @class_teacher=MgEmployee.where(:id=>@class_teacher_id[0])
        employee_obj = MgGuardian.where(:mg_user_id => session[:user_id],:mg_school_id=>session[:current_user_school_id])#.pluck(:first_name,:middle_name, :last_name)
        user_obj = MgUser.where(:id => session[:user_id])#.pluck(:user_name)
        not_sub =   "#{employee_obj[0][:first_name]} #{employee_obj[0][:middle_name]} #{employee_obj[0][:last_name]}(#{user_obj[0][:user_name]})  leave application"
        not_des ="#{employee_obj[0][:first_name]} #{employee_obj[0][:middle_name]} #{employee_obj[0][:last_name]}  has applied for leave from   #{@all_data[:from_date]}   to  #{@all_data[:to_date]}  with reason \"#{@all_data[:reason]}\"."
        db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id]   ,:to_user_id => @class_teacher[0].mg_user_id, :subject => not_sub,:description => not_des,:is_deleted => 0, :from_user_id => session[:user_id],:status => false )
        @message = Message.new
        @email_from = MgEmail.where(:mg_user_id => session[:user_id],mg_school_id:session[:current_user_school_id])

        @message.subject =  not_sub
        @message.description = not_des
        @email_to = MgEmail.where(:mg_user_id => @class_teacher[0].mg_user_idi,mg_school_id:session[:current_user_school_id])
        @message.to_user_id = @email_to[0][:mg_email_id ]
        @message.from_user_id = @email_from[0][:mg_email_id ]
                  # @message.from_user_id = 'kgaurav@mindcomgroup.com'
        server_response = NotificationMailer.send_mail(@message).deliver!
        @event_mail = MgMailStatus.create(:status_code => server_response.status,
                                                    :email_addrs_to => @message.to_user_id,
                                                    # current school Id will come here
                                              :mg_school_id => session[:current_user_school_id] ,
                                                    :email_addrs_by => @message.from_user_id,
                                                    :email_subject => not_sub,
                                                   :email_server_description => server_description(server_response.status) )

      @notice="Mail sent successfully."
    end
    rescue Net::SMTPFatalError => e
      puts "inside Exception in principal"
      flash.now[:notice]="Email Id is not valid"
      flash.keep(:notice)
    rescue ArgumentError => e
      puts "inside Exception in principal"
      flash.now[:notice]="Email to address is not present."
      flash.keep(:notice)
    rescue Exception => e
      puts "inside Exception in principal"
      flash.now[:notice]="Error while sending email, please contact admin."
      flash.keep(:notice)
    end

     if @stud_array.present?
      flash[:error] = "These Leave Applied Already (#{@stud_array.join(",") })"
    else
      flash[:notice] = "#{leave_date.length} Days Leave Applied successfully"
    end
  redirect_to :controller => 'dashboards', :action =>'guardian_leave',:notice=>@notice
  end

  def employee_student_attendance
     # @userID=session[:user_id]
     # incharge = ["attendance_incharge","school_incharge"]
     # if incharge.include?(session[:user_type])
     #   @batches=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
     # else
     #    @employee_id= MgEmployee.where(:mg_user_id => @userID).pluck(:id)
     #    @batches=MgBatch.where(:is_deleted=>0, :mg_employee_id=>@employee_id[0],:mg_school_id=>session[:current_user_school_id])
     # end

  end

  def get_batch_of_employee
    # incharge = ["attendance_incharge","school_incharge"]
    incharge = ["Attendance","school_incharge","attendance_incharge","principal","admin"]
    courses_ids =[]
    courses = view_context.get_course_by_academic_year(params[:mg_time_table_id]) if params[:mg_time_table_id].present?
    courses.each do |v, i| courses_ids << i end
    if incharge.include?(session[:user_type])
      @batches=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>courses_ids).joins(:mg_course).pluck("CONCAT(mg_courses.course_name,'-',mg_batches.name)","id")
    else
      @employee_id= MgEmployee.where(:mg_user_id => session[:user_id]).pluck(:id)
      @batches=MgBatch.where(:is_deleted=>0, :mg_employee_id=>@employee_id[0],:mg_school_id=>session[:current_user_school_id],:mg_course_id =>courses_ids).joins(:mg_course).pluck("CONCAT(mg_courses.course_name,'-',mg_batches.name)","id")
      @batches +=MgBatch.where(:is_deleted=>0, :second_mg_employee_id=>@employee_id[0],:mg_school_id=>session[:current_user_school_id],:mg_course_id =>courses_ids).joins(:mg_course).pluck("CONCAT(mg_courses.course_name,'-',mg_batches.name)","id")
    end
    render :json=> {courses_batches: @batches}, :layout => false
  end

  def time_table_for_attendance
    absent_date=params[:absentDate]
    school=MgSchool.find(session[:current_user_school_id])
    # date=Date.parse(absent_date.to_s).strftime("%d-%m-%Y")
    @employee_data = MgEmployee.find_by(mg_user_id:session[:user_id],is_deleted:0,is_archive:0,mg_school_id:session[:current_user_school_id])
    date=params[:absentDate]
    date_for_holiday="2024-11-06"
    puts "start from here"
    puts date
    puts "start from here"
    arr = date.split('-');
    month= arr[1].to_i
    year=arr[2].to_i
    day =arr[0].to_i
    absent_date =Date.new(year,month,day)
    absent_date.strftime("%w")
    puts "step --------1"
    puts absent_date.strftime("%w")
    puts "step --------2"
    @batches=MgBatch.find(params[:mg_batch_id])
    puts @batches.inspect
    @course=MgCourse.find(@batches.mg_course_id)
        puts @course.inspect
    puts "step----3"
    @weekdayID=MgWeekday.where(:is_deleted=>0, :mg_wing_id=> @course.mg_wing_id, :weekday=>absent_date.strftime("%w"), :mg_school_id=>session[:current_user_school_id]).pluck(:id)
    puts @weekdayID[0]
    puts "step --------3"
    
    # @timeings=MgClassTiming.where(:is_deleted=>0, :mg_batch_id=>params[:mg_batch_id], ).select(:start_time, :end_time).uniq
    @timeings=MgClassTiming.where(:is_deleted=>0, :mg_wing_id=> @course.mg_wing_id,:mg_weekday_id=>@weekdayID[0], :mg_school_id=>session[:current_user_school_id] )
    #@classtiming = @timeings.map{|a| a.id }
	@classtiming = @timeings.reject{|a| a.id if a.is_break == true}.map(&:id)
    #@students=MgStudent.where(:is_deleted=>0, :mg_batch_id=>params[:mg_batch_id], :mg_school_id=>session[:current_user_school_id], :is_archive=> 0)
    #@stud = @students.map{|s| s.id }
  #added for timer
  @end_time = ""
  if session[:user_type] == "employee"
    start_date = absent_date.to_date.beginning_of_day.to_s(:db)
    end_date = absent_date.to_date.end_of_day.to_s(:db)
    @finalize = MgAttendanceFinalizeTime.find_by(:mg_school_id=>session[:current_user_school_id],:is_deleted=>0,mg_batch_id:params[:mg_batch_id],mg_employee_id:@employee_data.id,finalize_time:start_date..end_date)
    @finalize_id = @finalize.id if @finalize.present?
    @finalize_check = @finalize.is_submit if @finalize.present?
    timer_duration_data = MgAttendanceSetting.find_by(:mg_wing_id=> @course.mg_wing_id,:mg_school_id=>session[:current_user_school_id],:is_deleted=>0)
    start_time = @finalize.finalize_time if @finalize.present?
    duration = timer_duration_data.time_duration if timer_duration_data.present?
    if start_time && duration.present?
      end_data = start_time + duration.minutes
      @end_time = end_data.strftime("%Y-%m-%d %H:%M")
    end
  end

    mg_batch_id = params[:mg_batch_id]
    time_table = params[:mg_time_table_id]
    if mg_batch_id.present?
      @students = view_context.get_students_by_academic_year(time_table,mg_batch_id,session[:current_user_school_id])
      @stud =  @students.map(&:id)if @students.present?
    end
     if params[:sort]=="class_roll_number"
         @students = view_context.get_students_by_academic_year(time_table,mg_batch_id,session[:current_user_school_id]).order("class_roll_number")
      elsif params[:sort]=="admission_number"
        @students = view_context.get_students_by_academic_year(time_table,mg_batch_id,session[:current_user_school_id]).order("admission_number" )
      elsif params[:sort]=="first_name"
        @students = view_context.get_students_by_academic_year(time_table,mg_batch_id,session[:current_user_school_id]).order("first_name")
      else
        @students = view_context.get_students_by_academic_year(time_table,mg_batch_id,session[:current_user_school_id]).order("roll_number
          ")
      end
      @sort_by = params[:sort].present? ? params[:sort] : "roll_number" 

    @absentDate=MgStudentAttendance.where(:mg_batch_id=>params[:mg_batch_id], :is_deleted=>0, :absent_date=>absent_date, :mg_school_id=>session[:current_user_school_id])
    holidays="select holiday_name,holiday_start_date from mg_holidays where is_deleted = 0 
                  and mg_school_id = #{session[:current_user_school_id]} 
                  and ( holiday_start_date = '#{date_for_holiday}' 
                  or holiday_end_date = '#{date_for_holiday}' 
                  or(holiday_start_date < '#{date_for_holiday}' 
                  and holiday_end_date > '#{date_for_holiday}'))
                  and ( is_for_student = 1 or applicable_for ='All')"
    @holiday_dates = MgHoliday.find_by_sql(holidays)
    if params[:isapi].present? 
      render json: @students, status: :created
    else
      render layout: false 
    end
    
  end

  def update_absent
    absent_date = params[:absentDate].to_date
    student = params[:checkedVal]
    timing = params[:classtiming].split().map(&:to_i) if params[:classtiming].present?
    if student.present?
      update_absent = []
      student.each do |stud_id|
        timing.each do |time|
          absentDate = MgStudentAttendance.where(:mg_student_id=>stud_id, :absent_date=>absent_date, :mg_batch_id=>params[:mg_batch_id],:mg_school_id=>session[:current_user_school_id],:mg_class_timing_id=>time)

          if absentDate.present?
	absentDate.update_all(:is_deleted =>0)
	else
             absentDate = MgStudentAttendance.new
             absentDate.mg_student_id = stud_id
             absentDate.absent_date = absent_date
             absentDate.mg_batch_id = params[:mg_batch_id]
             absentDate.mg_class_timing_id = time
             absentDate.mg_school_id = session[:current_user_school_id]
             absentDate.is_deleted = 0
             absentDate.created_by = session[:user_id]
             absentDate.updated_by = session[:user_id]
             update_absent << absentDate
          end
        end
      end
      columns_without_id = MgStudentAttendance.column_names.reject { |column_name| column_name == 'id' }
      save_absent_student = MgStudentAttendance.import(columns_without_id, update_absent) 
    end
    render :json => {:status => :ok}
  end

  def get_student_data
    @students = MgStudent.where(id:params[:checkedVal],is_deleted:0,is_archive:0,mg_school_id:session[:current_user_school_id])
    render :layout => false
  end

  def update_present
    absent_date = params[:absentDate].to_date
    student = params[:checkedVal]
    unchecked_student = params[:uncheckedVal]
    timing = params[:classtiming].split().map(&:to_i) if params[:classtiming].present?
    if student.present?
      absent_id = []
      student.each do |stud_id|
        timing.each do |time|
          present_student = MgStudentAttendance.find_by(:mg_student_id=>stud_id,:absent_date=>absent_date,:mg_batch_id=>params[:mg_batch_id],:mg_school_id=>session[:current_user_school_id],:mg_class_timing_id=>time, :is_deleted=>0)
          if present_student.present?
            absent_id << present_student.id
          end
        end
      end
      if absent_id.present?
        absent_ids = absent_id.map(&:inspect).join(', ')
        sql = "UPDATE mg_student_attendances SET is_deleted = 1 WHERE id in (#{absent_ids});"
        make_present = ActiveRecord::Base.connection.execute("#{sql}")
      end
    end
    if unchecked_student.present?
      update_absent = []
      unchecked_student.each do |stud_id|
        timing.each do |time|
          absent_student = MgStudentAttendance.find_by(:mg_student_id=>stud_id,:absent_date=>absent_date,:mg_batch_id=>params[:mg_batch_id],:mg_school_id=>session[:current_user_school_id],:mg_class_timing_id=>time, :is_deleted=>0)
          if !absent_student.present?
            absent_student = MgStudentAttendance.new
            absent_student.mg_student_id = stud_id
            absent_student.absent_date = absent_date
            absent_student.mg_batch_id = params[:mg_batch_id]
            absent_student.mg_class_timing_id = time
            absent_student.mg_school_id = session[:current_user_school_id]
            absent_student.is_deleted = 0
            absent_student.created_by = session[:user_id]
            absent_student.updated_by = session[:user_id]
            update_absent << absent_student
          end
        end
      end
      columns_without_id = MgStudentAttendance.column_names.reject { |column_name| column_name == 'id' }
      update_absent_student = MgStudentAttendance.import(columns_without_id, update_absent) 
    end
    render :json => {:status => :ok}
  end



  def period_attendence_save
    @mg_class_timing_id=params[:mg_class_timing_id]

    school=MgSchool.find(session[:current_user_school_id])
      date=Date.strptime(params[:absentDate],school.date_format)
      absent_date = params[:absentDate].to_date.to_s(:db)
    if  params[:is_reason]=='true' && params[:edit]=='true' 
      

      
      date_farmate=Date.parse(date.to_s).strftime("%d-%m-%Y")
      # date=Date.parse(absent_date.to_s).strftime("%d-%m-%Y")
      arr = date_farmate.split('-');
                month= arr[1].to_i
                year=arr[2].to_i
                day =arr[0].to_i
      absent_date =Date.new(year,month,day)
      @attendances=MgStudentAttendance.where(:is_deleted=>0, :mg_batch_id=>params[:mg_batch_id], :mg_school_id=>session[:current_user_school_id], :mg_class_timing_id=>params[:mg_class_timing_id], :mg_student_id=>params[:mg_student_id],:absent_date=>absent_date).pluck(:id)
      
      @attendances_find=MgStudentAttendance.find(@attendances[0])
      @attendances_find.update(:is_deleted=>1)
      
    elsif params[:is_reason]=='true'
      @attendances=MgStudentAttendance.where(:mg_batch_id=>params[:mg_batch_id], :mg_school_id=>session[:current_user_school_id], :mg_class_timing_id=>params[:mg_class_timing_id], :mg_student_id=>params[:mg_student_id],:absent_date=>absent_date)
      if @attendances[0].present?
        @attendances[0].update(is_deleted:0)
      else
        @attendances=MgStudentAttendance.new(:is_deleted=>0, :mg_batch_id=>params[:mg_batch_id], :mg_school_id=>session[:current_user_school_id], :mg_class_timing_id=>params[:mg_class_timing_id], :mg_student_id=>params[:mg_student_id],:absent_date=>date, :created_by=>session[:user_id], :updated_by=>session[:user_id])
        @attendances.save
      end
     
      #for sms
      # student_obj = MgStudent.where(:id =>  params[:mg_student_id])
      # guardianList = MgStudentGuardian.where(:mg_student_id => params[:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:has_login_access=>1).pluck(:mg_guardians_id)
      # if guardianList.empty?
      #   puts " Guadian not present "
      # else
      #   puts " Guardian present"
      #   guardianList.each do |g|
      #     guar = MgGuardian.where(:id => g.to_i).pluck(:mg_user_id)
      #     puts guar.inspect
      #     # @sms=sms(guar,student_obj,params[:absentDate])
      #   end
      # end
      #for sms ends
    else
    end
     @attendances=MgStudentAttendance.new()
    @batchId=params[:mg_batch_id]
    @student_id=params[:mg_student_id]
    @final_date =params[:absentDate]    
    # @attendances.save
    # mg_class_timing_id: mg_class_timing_id, mg_batch_id: batchID, 
    # absentDate: absentDate, mg_student_id: mg_student_id, mg_school_id: mg_school_id, created_by: created_by, updated_by: updated_by
    render :layout => false

  end

  def attendance_new_period
    absent_date=params[:absentDate]
    
    @batchId=params[:batchID]
    @student_id=params[:mg_student_id]
    # date=Date.parse(absent_date.to_s).strftime("%d-%m-%Y")
     school=MgSchool.find(session[:current_user_school_id])
      date=Date.strptime(params[:absentDate],school.date_format)
      date_farmate=Date.parse(date.to_s).strftime("%d-%m-%Y")
    @final_date=params[:absentDate]
    arr = date_farmate.split('-');  
                month = arr[1].to_i
                year=arr[2].to_i
                day =arr[0].to_i
    absent_date =Date.new(year,month,day)

    absent_date.strftime("%w")

     @batches=MgBatch.find(params[:batchID])
    @course=MgCourse.find(@batches.mg_course_id)
    @weekdayID=MgWeekday.where(:is_deleted=>0, :mg_wing_id=> @course.mg_wing_id, :weekday=>absent_date.strftime("%w"), :mg_school_id=>session[:current_user_school_id]).pluck(:id)
    puts @weekdayID[0]

    # @timeings=MgClassTiming.where(:is_deleted=>0, :mg_batch_id=>params[:mg_batch_id], ).select(:start_time, :end_time).uniq
    @timeings=MgClassTiming.where(:is_deleted=>0, :mg_wing_id=> @course.mg_wing_id,:mg_weekday_id=>@weekdayID[0], :is_break=>0 , :mg_school_id=>session[:current_user_school_id])

    @absentDate=MgStudentAttendance.where(:mg_batch_id=>params[:batchID], :is_deleted=>0, :absent_date=>absent_date, :mg_school_id=>session[:current_user_school_id])
    render :layout => false

  end


  def attendance_create
      puts "step    -----createstudent-----"
      school = MgSchool.find(session[:current_user_school_id])
      puts params[:absent_date]

      if params[:absent_date].present?
        date=Date.strptime(params[:absent_date],school.date_format)
        date_format=Date.parse(date.to_s).strftime("%d-%m-%Y")
      end

      if params[:attendancedate]=="periodwise"
        puts "step    -----createstudent-----periodwise"
        @attendance=MgStudentAttendance.new(ajax_params)
        @attendance.absent_date=date
        @attendance.save
      elsif params[:attendancedate]== "periodwiseedit"
        puts "step    -----createstudent-----periodwiseedit"
        @attendance=MgStudentAttendance.find(params[:id])
        @attendance.reason=params[:reason]
        @attendance.updated_by=session[:user_id]
        @attendance.save
      else
        puts "step    -----1-----"
        @all_data=params.permit(:mg_student_id, :absent_date, :mg_period_table_entry_id, :is_afternoon, :is_halfday, :reason, :mg_batch_id ,:is_deleted, :mg_school_id, :created_by, :updated_by)
        check=params.permit(:checkedvalue, :uncheckedvalue)
        date_formate=Date.parse(date.to_s).strftime("%d-%m-%Y")
        arr = date_formate.split('-');
        month= arr[1].to_i
        year=arr[2].to_i
        day =arr[0].to_i
        absent_date =Date.new(year,month,day)
        checkedvalue=params[:checkedvalue]
        if params[:checkedvalue].present?
          for i in 0...params[:checkedvalue].size
            @attendances=MgStudentAttendance.where(:mg_student_id=>params[:mg_student_id], :absent_date=>absent_date, :mg_batch_id=>params[:mg_batch_id],:mg_school_id=>params[:mg_school_id],:mg_class_timing_id=>checkedvalue[i])
            puts "object check ---- 1"
            @attendances.inspect
            puts "object check ---- 1"

            if @attendances[0].present?
              @attendance=MgStudentAttendance.find(@attendances[0].id)
              @attendance.mg_class_timing_id=params[:checkedvalue][i]
              @attendance.reason=params[:reason]
              @attendance.is_deleted = 0
              @attendance.save
            else
              @attendances=MgStudentAttendance.new(ajax_params)
              @attendances.mg_class_timing_id=params[:checkedvalue][i]
              @attendances.absent_date=absent_date
              @attendances.reason=params[:reason]
              @attendances.save
            end
          end
        end
        uncheckedvalue=params[:uncheckedvalue]
        if params[:uncheckedvalue].present?
          for i in 0...params[:uncheckedvalue].size
            @attendances=MgStudentAttendance.where(:mg_student_id=>params[:mg_student_id], :absent_date=>absent_date, :mg_batch_id=>params[:mg_batch_id],:mg_school_id=>params[:mg_school_id],:mg_class_timing_id=>params[:uncheckedvalue][i], :is_deleted=>0)
            if @attendances[0].present?
              puts "i am if "
              @attendance=MgStudentAttendance.find(@attendances[0].id)
              @attendance.is_deleted=1
              @attendance.save
            end
          end
        end
      end
    begin
      student_obj = MgStudent.where(:id =>  params[:mg_student_id], :is_archive=> 0)
      guardianList = MgStudentGuardian.where(:mg_student_id => params[:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:has_login_access=>1).pluck(:mg_guardians_id)
      not_sub =   "#{student_obj[0][:first_name]} #{student_obj[0][:middle_name]} #{student_obj[0][:last_name]} is absent on #{ params[:absent_date] }"
      not_des ="Dear Sir/Madam \n your child #{student_obj[0][:first_name]} #{student_obj[0][:middle_name]} #{student_obj[0][:last_name]}  is absent on #{ params[:absent_date] }."
      if guardianList.empty?
        puts " Guadian not present "
      else
        puts " Guardian present"
        guardianList.each do |g|
          guar = MgGuardian.where(:id => g.to_i,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_user_id)
          puts guar.inspect
          # @sms=sms(guar,student_obj,params[:absent_date])
          db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id],:to_user_id => guar[0].to_i, :subject => not_sub,:description => not_des,:is_deleted => 0, :from_user_id => session[:user_id],:status => false )

          @message = Message.new
          @email_from = MgEmail.where(:mg_user_id => session[:user_id],mg_school_id:session[:current_user_school_id])

          @message.subject =  not_sub
          @message.description = not_des
         
          @email_to = MgEmail.where(:mg_user_id => guar[0].to_i,mg_school_id:session[:current_user_school_id])

      # binding.pry
          # @message.to_user_id = @email_to[0][:mg_email_id ]
          # @message.from_user_id = @email_from[0][:mg_email_id ]
          # server_response = NotificationMailer.send_mail(@message).deliver!
          # @event_mail = MgMailStatus.create(:status_code => server_response.status,
          #                                         :email_addrs_to => @message.to_user_id,
          #                                         # current school Id will come here
          #                                        :mg_school_id =>  session[:current_user_school_id] ,
          #                                         :email_addrs_by => @message.from_user_id,
          #                                         :email_subject => not_sub,
          #                                        :email_server_description => server_description(server_response.status) )
        end
      end
      rescue Net::SMTPFatalError => e
      puts "inside Exception in principal"
      flash.now[:notice]="Email Id is not valid"
      flash.keep(:notice)
      render :js => "alert('Email Id is not valid.#{@sms}');"
    rescue ArgumentError => e
      puts "inside Exception in principal"
      flash.now[:notice]="Email to address is not present."
      flash.keep(:notice)
      render :js => "alert('Email to address is not present.#{@sms}');"
    rescue Exception => e
      puts "inside Exception in principal"
      flash.now[:notice]="Error while sending email, please contact admin."
      flash.keep(:notice)
      render :js => "alert('Error while sending email, please contact admin.#{@sms}');"
    end
   # redirect_to :action =>'employee_student_attendance',:notice=>@attendance_notification
  end
  #=================================for sending sms============
   # for sms_send
   def sms(user_id,student_obj,absent_date)
             activity=Action.find_by(:sms_activity=>"Attendance")
             school=MgSchool.find_by(:id=>session[:current_user_school_id])
             sms_template=Template.find_by(:is_deleted=>0)
             template=Template.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:action_id=>activity.id)
          if template.present?
          template1=Template.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:action_id=>activity.id)
          else
             template1=Template.find_by(:is_deleted=>0,:action_id=>activity.id)
           end
             puts "template message"
             puts template1.message
             template=template1.message
             template["$User_name"]= "#{student_obj[0][:first_name]} #{student_obj[0][:middle_name]} #{student_obj[0][:last_name]}"
             template["$School_name"]= "#{school.school_name}"
             template["$Current_date"]= "#{absent_date }"
             puts template
             sms_notifi=send_sms_notification(session[:user_id],template,user_id,"Attendance",session[:current_user_school_id])
          return sms_notifi
        end
             #sms ends
  #=====================SENDING SMS ENDS

  def period_attendence_edit
      # date_format=Date.parse(params[:absentDate].to_s).strftime("%d-%m-%Y")
    school = MgSchool.find(session[:current_user_school_id])
    puts "i'm here"
      puts params[:absentDate]
      date=Date.strptime(params[:absentDate],school.date_format)
      date_format=Date.parse(date.to_s).strftime("%d-%m-%Y")
      @attendances=MgStudentAttendance.new()
      arr = date_format.split('-');
                      month= arr[1].to_i
                      year=arr[2].to_i
                      day =arr[0].to_i
          absent_date =Date.new(year,month,day)
    # @batchId=params[:mg_batch_id]
    # @student_id=params[:mg_student_id]
    # @final_date =params[:absentDate]
    # @mg_class_timing_id=params[:mg_class_timing_id]
    @attendances=MgStudentAttendance.where(:mg_batch_id=>params[:mg_batch_id],:mg_student_id=>params[:mg_student_id], :absent_date=>absent_date ,:mg_school_id=>session[:current_user_school_id],:mg_class_timing_id=>params[:mg_class_timing_id], :is_deleted=>0).pluck(:id)
    puts "serp -------1"
    puts @attendances[0].inspect
    puts "serp -------1"
    @attendances=MgStudentAttendance.find(@attendances[0])
    # mg_class_timing_id: mg_class_timing_id, mg_batch_id: batchID, 
    # absentDate: absentDate, mg_student_id: mg_student_id, 
    # mg_school_id: mg_school_id, created_by: created_by, updated_by: updated_by
    render :layout => false
    
  end

  def period_wise_attendance_for_student
    school = MgSchool.find(session[:current_user_school_id])
      
      date=Date.strptime(params[:absentDate],school.date_format)
      absent_date=Date.parse(date.to_s).strftime("%d-%m-%Y")
     # date_format=Date.parse(params[:absentDate].to_s).strftime("%d-%m-%Y")
    # absent_date=params[:absentDate]
    arr = absent_date.split('-');
                month= arr[1].to_i
                year=arr[2].to_i
                day =arr[0].to_i
    absent_date =Date.new(year,month,day)
    absent_date.strftime("%w")
    puts "step --------1"
    puts absent_date.strftime("%w")
    puts "step --------2"
    @batches=MgBatch.find(params[:mg_batch_id])
    puts @batches.inspect
    @course=MgCourse.find(@batches.mg_course_id)
        puts @course.inspect
    puts "step----3"
    @weekdayID=MgWeekday.where(:is_deleted=>0, :mg_wing_id=> @course.mg_wing_id, :weekday=>absent_date.strftime("%w"), :mg_school_id=>session[:current_user_school_id]).pluck(:id)
    puts @weekdayID[0]
    puts "step --------3"

    # @timeings=MgClassTiming.where(:is_deleted=>0, :mg_batch_id=>params[:mg_batch_id], ).select(:start_time, :end_time).uniq
    @timeings=MgClassTiming.where(:is_deleted=>0, :mg_wing_id=> @course.mg_wing_id,:mg_weekday_id=>@weekdayID[0], :mg_school_id=>session[:current_user_school_id] )

   
    @absentDate=MgStudentAttendance.where(:mg_batch_id=>params[:mg_batch_id], :is_deleted=>0, :absent_date=>absent_date, :mg_school_id=>session[:current_user_school_id], :is_deleted=>0)

   

    @check_user=MgUser.where(:user_type=>'student', :id=>session[:user_id], :mg_school_id=>session[:current_user_school_id], :is_deleted=>0)
    if @check_user.present?
      @student_id=MgStudent.where(:mg_user_id=>session[:user_id], :mg_school_id=>session[:current_user_school_id], :is_deleted=>0, :is_archive=> 0).pluck(:id)
      @students=MgStudent.where(:is_deleted=>0, :mg_batch_id=>params[:mg_batch_id], :id=>@student_id[0], :mg_school_id=>session[:current_user_school_id], :is_deleted=>0, :is_archive=> 0)
    end
    @check_user_gardian=MgUser.where(:user_type=>'student', :id=>session[:user_id], :mg_school_id=>session[:current_user_school_id], :is_deleted=>0)
    if (@check_user_gardian.present?)
    end
    render :layout => false
   

  end

  # def period_wise_attendance_for_student_guardian
  #   absent_date=params[:absentDate]
  #   arr = absent_date.split('-');
  #               month= arr[1].to_i
  #               year=arr[2].to_i
  #               day =arr[0].to_i
  #   absent_date =Date.new(year,month,day)
  #   absent_date.strftime("%w")
  #   # puts "step --------1"
  #   # puts absent_date.strftime("%w")
  #   # puts "step --------2"
  #   # # @batches=MgBatch.find(params[:mg_batch_id])
  #   # puts @batches.inspect
  #   # @course=MgCourse.find(@batches.mg_course_id)
  #   #     puts @course.inspect
  #   # puts "step----3"
  #   @weekdayID=MgWeekday.where(:is_deleted=>0, :weekday=>absent_date.strftime("%w"), :mg_school_id=>session[:current_user_school_id]).pluck(:id)
  #   puts @weekdayID[0]
  #   puts "step --------3"

  #   # @timeings=MgClassTiming.where(:is_deleted=>0, :mg_batch_id=>params[:mg_batch_id], ).select(:start_time, :end_time).uniq
  #   @timeings=MgClassTiming.where(:is_deleted=>0,:mg_weekday_id=>@weekdayID[0], :mg_school_id=>session[:current_user_school_id] )

   
  #   @absentDate=MgStudentAttendance.where( :is_deleted=>0, :absent_date=>absent_date, :mg_school_id=>session[:current_user_school_id], :is_deleted=>0)

   

    
  #   @check_user_gardian=MgUser.where(:user_type=>'guardian', :id=>session[:user_id], :mg_school_id=>session[:current_user_school_id], :is_deleted=>0)
  #   if (@check_user_gardian.present?)
  #   @Guardian= MgGuardian.where(:mg_user_id => session[:user_id], :mg_school_id=>session[:current_user_school_id], :is_deleted=>0).pluck(:id)

  #     # @sql = "SELECT * from mg_students S,mg_guardians G ,mg_student_guardians M Where M.mg_guardians_id  = #{@Guardian[0]} And S.id = M.mg_student_id and G.id = M.mg_guardians_id and S.is_deleted=0 and S.mg_school_id=#{session[:current_user_school_id]} and G.is_deleted=0 and G.mg_school_id=#{session[:current_user_school_id]} and M.is_deleted=0 and M.mg_school_id=   #{session[:current_user_school_id]}"
  #     @sql="SELECT S.first_name, S.id , S.mg_batch_id from mg_students S,mg_guardians G ,mg_student_guardians M Where M.mg_guardians_id  = 1 And S.id = M.mg_student_id and G.id = M.mg_guardians_id and S.is_deleted=0 and S.mg_school_id=5 and G.is_deleted=0 and G.mg_school_id=5 and M.is_deleted=0 and M.mg_school_id=5"
  #     @students=MgStudent.find_by_sql(@sql)
  #     puts "@student_gardian"
  #     puts @students.inspect
  #     puts "@student_gardian"
  #   end
  #   render :layout => false
    
  # end
  def attendance_import
    mg_school_id=session[:current_user_school_id]
    user_id=session[:user_id]
    if params[:is_day_attendance]!='1'
    begin
    @demo=MgStudentAttendance.import_attendance(params[:file], mg_school_id, user_id)
    puts @demo.inspect
      @error_object="Imported successfully."

    rescue Exception => exc
    @error_object="Importing was unsuccessful, please provide the proper data."
      
    end

    else
    begin

    MgStudentAttendance.import_with_day_wise(params[:file], mg_school_id, user_id)
    @error_object="Imported successfully."

    rescue Exception => exc
    @error_object="Importing was unsuccessful, please provide the proper data."

    end

    end
   

    redirect_to :action=>'employee_student_attendance', notice: @error_object

  end

  

  private

  def attes_params
    params.require(:attendances).permit(:mg_batch_id, :mg_student_id, :is_afternoon, :is_halfday, :reason, :absent_date, :mg_batch_id ,:is_deleted, :mg_school_id, :created_by, :updated_by)
  end

  def ajax_params
    params.permit(:mg_class_timing_id, :mg_student_id, :absent_date, :mg_period_table_entry_id, :is_afternoon, :is_halfday, :reason, :mg_batch_id ,:is_deleted, :mg_school_id, :created_by, :updated_by)
  end 

  def holiday_params
      params.require(:holiday).permit(:holiday_name,:description,:is_deleted, :mg_school_id, :created_by, :updated_by)
  end 

  
end
