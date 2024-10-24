class StudentCategoriesController < ApplicationController
    layout "mindcom"
    # before_action :set_mg_student_category, only: [:show, :edit, :update, :destroy]
    # before_action :login_required
  
  
    def index
      @student_category = MgStudentCategory.where(is_deleted: false, mg_school_id: session[:current_user_school_id])
      respond_to do |format|
        format.html # renders the default index.html.erb
        format.json do
          if params[:api_request].present?
            render json: @student_category, status: :created
          else
            render json: { error: "API request parameter missing" }, status: :bad_request
          end
        end
      end
    end
  
    # def show
    # end
  
    def new
      @student_category = MgStudentCategory.new
    end
  
  
    def edit
      @id = params[:id]
    end
  
    def create
      @student_category = MgStudentCategory.new(mg_create_student_category_params)
      
      @student_category.mg_school_id = session[:current_user_school_id]
        @student_category.is_deleted= 0
        @student_category.created_by= session[:user_id]
        @student_category.updated_by= session[:user_id]
        if @student_category.save
          render json: { message: "Academic year Created"}, status: :created
        end
    end
  
    def update



      @student_category = MgStudentCategory.find(params[:id])
      if @student_category.update(mg_student_category_params)
        render json: { message: "Category Updated"}, status: :created
      end
      
    end
  
    def destroy
      @student_category.destroy
      flash[:notice] = "Student category deleted successfully"
      redirect_to student_categories_url
    end
  
    def delete
      @student_category = MgStudentCategory.find(params[:id])
      
      boolVal = MgDependancyClass.studentCategory_dependancy("mg_student_category_id",params[:id])
      if boolVal == true
        flash[:error]  = "Cannot Delete this Caste is Having Dependencies"
      else
         @student_category.update(:is_deleted=>1)
          flash[:notice] = "Deleted Successfully"
       end

      
      render json: { message: "Category Deleted Successfully" }, status: :ok
    end
  
    private
  
    def set_mg_student_category
      @student_category = MgStudentCategory.find(params[:id])
    end
  
    def mg_student_category_params
      params.require(:student_category).permit(:name, :is_deleted, :mg_school_id)
    end
  
    def mg_create_student_category_params
      params.require(:student_category).permit(:name, :is_deleted, :mg_school_id)
    end
  end