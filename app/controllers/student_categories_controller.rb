class StudentCategoriesController < ApplicationController
    layout "mindcom"
    # before_action :set_mg_student_category, only: [:show, :edit, :update, :destroy]
    # before_action :login_required
  
  
    def index
      @mg_student_categories = MgStudentCategory.where(is_deleted: false, mg_school_id: session[:current_user_school_id])
      if request.xhr?
        @index = params[:data]
        render layout: false
      end
    end
  
    # def show
    # end
  
    def new
      @mg_student_category = MgStudentCategory.new
    end
  
  
    def edit
      @id = params[:id]
    end
  
    def create
      @mg_student_category = MgStudentCategory.new(mg_create_student_category_params)
      
      if @mg_student_category.save
        flash[:notice] = "Student category created successfully"
        redirect_to student_categories_path
      else
        flash[:error] = "Error creating student category"
        render :new
      end
    end
  
    def update
      if @student_category.update(mg_student_category_params)
        flash[:notice] = "Student category updated successfully"
        redirect_to student_categories_path
      else
        flash[:error] = "Error updating student category"
        render :edit
      end
    end
  
    def destroy
      @student_category.destroy
      flash[:notice] = "Student category deleted successfully"
      redirect_to student_categories_url
    end
  
    def delete
      @student_category = MgStudentCategory.find(params[:id])
      
      if MgDependancyClass.studentCategory_dependancy("mg_student_category_id", params[:id])
        flash[:error] = "Cannot delete this category, as it has dependencies"
      else
        @student_category.update(is_deleted: true)
        flash[:notice] = "Category deleted successfully"
      end
      
      redirect_to student_categories_path
    end
  
    private
  
    def set_mg_student_category
      @student_category = MgStudentCategory.find(params[:id])
    end
  
    def mg_student_category_params
      params.require(:mg_student_category).permit(:name, :is_deleted, :mg_school_id)
    end
  
    def mg_create_student_category_params
      params.require(:student_category).permit(:name, :is_deleted, :mg_school_id)
    end
  end