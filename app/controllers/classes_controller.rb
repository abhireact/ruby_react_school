class ClassesController < ApplicationController
  layout 'mindcom'
  # before_action :login_required
  # helper_method :user_signed_in?

  # com
  #    before_filter :user_signed_in?

  # def user_signed_in?
  # 	# check user is logged in or not
  # 	logger.info "Step -- 1"

  # 	logger.info session[:user_id]
  # 	logger.info "Step -- 2"
  # end
  # layout false

  def index
    if session[:class_table].present?
      @table_array = session[:class_table]
      @course_id = session[:table_array_class_id]
      session[:table_array_employee_id] = nil
      session[:class_table] = nil
    end
    # @current_academic_year = view_context.get_current_academic_year(session[:current_user_school_id])
    @current_academic_year_id = 175
    @current_academic_year_id = params[:mg_time_table_id] if params[:mg_time_table_id]
    @classes = MgCourse.where(mg_school_id: session[:current_user_school_id], is_deleted: 0,
                              mg_time_table_id: @current_academic_year_id).order(:id)
    @batches = MgBatch.find_by(mg_school_id: session[:current_user_school_id], is_deleted: 0)

    # Fetch all academic year data for the current school
    @academic_year_data = MgTimeTable.where(mg_school_id: session[:current_user_school_id], is_deleted: 0).order(:id)

    # Get wings data linked to the selected academic year
    @wings_data = MgWing.where(mg_school_id: session[:current_user_school_id], is_deleted: 0)

    # Prepare data for the frontend in React or similar framework
    @react_data = {
      table_array: @table_array,
      course_id: @course_id,
      classes: @classes,
      batches: @batches,
      current_academic_year_id: @current_academic_year_id,
      academic_year_data: @academic_year_data,
      wings_data: @wings_data
    }
  end

  def new
    @courses = MgCourse.new
    @academic_name = MgTimeTable.where(is_deleted: 0, mg_school_id: session[:current_user_school_id]).pluck(:name,
                                                                                                            'CONCAT(mg_time_tables.start_date,"+",mg_time_tables.end_date,"+",mg_time_tables.id)')
    @grades = MgExamSystem.where(is_enabled: 0).pluck(:grading_name, :grading_system)
    @schoolWing = MgWing.where(is_deleted: 0, mg_school_id: session[:current_user_school_id]).pluck(:wing_name, :id)

    # render :layout => false
  end

  def course_by_admin
    @courses = MgCourse.new
    # render :layout => false
  end

  def edit
    @schoolWing = MgWing.where(is_deleted: 0, mg_school_id: session[:current_user_school_id]).pluck(:wing_name, :id)
    @course = MgCourse.find(params[:id])
    @grades = MgExamSystem.where(is_enabled: 0).pluck(:grading_name, :grading_system)
    @schoolWings = MgWing.where(is_deleted: 0, mg_school_id: session[:current_user_school_id]).pluck(:wing_name, :id)
    @academic_name = MgTimeTable.where(is_deleted: 0, mg_school_id: session[:current_user_school_id]).pluck(:name,
                                                                                                            'CONCAT(mg_time_tables.start_date,"+",mg_time_tables.end_date,"+",mg_time_tables.id)')
    # @academic_name = MgTimeTable.where(:id=>@course.mg_time_table_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name, 'CONCAT(mg_time_tables.start_date,"+",mg_time_tables.end_date,"+",mg_time_tables.id)')
    # puts @academic_name[0][1].inspect
    # ll
    # render :layout => false
  end

  def create
    logger.info 'Course Create Method'
    @course = MgCourse.new(course_params)
    @course.mg_time_table_id = params[:mg_time_table_id].to_i
    @course.mg_school_id = session[:current_user_school_id]
    @course.is_deleted = 0
    @course.save
    if @course.present?
      @batch = MgBatch.new(batch_params)
      @batch.mg_course_id = @course.id
      @timeformat = MgSchool.find_by_id(session[:current_user_school_id])
      @startSaveDate = Date.strptime(params[:batch][:start_date], @timeformat.date_format)
      @endSaveDate = Date.strptime(params[:batch][:end_date], @timeformat.date_format)

      @batch.start_date = @startSaveDate
      @batch.end_date = @endSaveDate
      @batch.is_deleted = 0
      @batch.mg_school_id = session[:current_user_school_id]
      @batch.created_by = session[:user_id]
      @batch.updated_by = session[:user_id]

      render json: { message: 'Class Created Created' }, status: :created if @batch.save
      puts 'Batch Saving data'
      puts @batch.inspect
    end
    flash[:notice] = ' Class Created Successfully'

    # redirect_to controller: 'classes', action: 'index'
  end

  def check
    add_breadcrumb 'modeltest-check', courses_check_path
  end

  def modeltest
    add_breadcrumb 'modeltest', courses_modeltest_path
  end

  def show
  end

  def addBatch
    logger.info 'Batch will going to create'
  end

  def delete
    puts 'inside delete'
    @course = MgCourse.find(params[:id])
    table_array = @course.can_destroy?
    if table_array.present?
      session[:class_table] = table_array
      session[:table_array_class_id] = params[:id]
      redirect_to action: 'index'

    else
      @course.update(is_deleted: 1)
      @notice = 'Deleted Successfully'
      flash[:notice] = @notice
      redirect_to action: 'index'
    end
  end

  def grouped_batches
    @course = MgCourse.find(params[:id])
    @batch_groups = @course.mg_batch_groups
    @batches = @course.active_batches
    @batch_group = MgBatchGroup.new
  end

  def create_batch_group
    @name = params[:batch_group]
    @batch_group = MgBatchGroup.new(name: @name)

    @course = MgCourse.find(params[:course_id])
    @batch_group.mg_course_id = @course.id
    @error = false
    @error = true if params[:batch_ids].blank?
    if @batch_group.valid? and @error == false
      @batch_group.save
      batches = params[:batch_ids]
      batches.each do |batch|
        MgGroupedBatch.create(mg_batch_group_id: @batch_group.id, mg_batch_id: batch)
      end

    else

    end
  end

  def update
    @course = MgCourse.find(params[:id])

    logger.info ' index page ' if @course.update(mg_course_params)
    flash[:notice] = 'Class Updated Successfully'
    return unless @course.update(mg_course_params)

    render json: { message: 'Classes  updated' }, status: :created
  end
  # binding.pry

  private

  def mg_course_params
    params.require(:course).permit(:course_name, :section_name, :code, :grading_type, :mg_wing_id, :index)
  end

  def course_params
    params.require(:mg_course).permit(:course_name, :section_name, :code, :is_deleted, :grading_type, :mg_school_id,
                                      :mg_wing_id, :created_by, :updated_by, :index)
  end

  def batch_params
    # date is not saving
    # params.require(:batch).permit( :name,:start_date,:end_date,:is_deleted,:mg_school_id)
    params.require(:batch).permit(:name, :is_deleted, :mg_school_id, :created_by, :updated_by)
  end
end
