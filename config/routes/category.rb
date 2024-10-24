Rails.application.routes.draw do
  # CRUD operations for castecategory
    get 'category/edit'
    # get 'category/show'
    get 'category/castecategory'
    get 'category/getdata', to: 'category#castecategory'


    post 'category/castecategory', to: 'category#castecategory_create'
    patch 'category/castecategory/:id', to: 'category#castecategory_update'
    put 'category/castecategory/:id', to: 'category#castecategory_update'
    delete 'category/castecategory/:id', to: 'category#castecategory_delete'


    #CRUD operations for caste
    get 'category/caste', to: 'category#caste'
  post 'category/caste', to: 'category#create'
  get 'category/caste/:id', to: 'category#caste_show'
  patch 'category/caste/:id', to: 'category#caste_update'
  delete 'category/caste/:id', to: 'category#caste_delete'
    

  #CRUD operations for sports
  get 'category/sports', to: 'category#sport'
  post 'category/sports', to: 'category#sport_create'
  patch 'category/sports/:id', to: 'category#sport_update'
  delete 'category/sports/:id', to: 'category#sport_delete'



   #CRUD operations for Student Hoobies
   get 'category/student_hobbies', to: 'category#student_hobbies'
   post 'category/student_hobbies', to: 'category#student_hobbies_create'
   patch 'category/student_hobbies/:id', to: 'category#student_hobbies_update'
   delete 'category/student_hobbies/:id', to: 'category#student_hobbies_delete'



   #CRUD operations for Houses Details
   get 'category/house_details', to: 'category#house_details'
   post 'category/house_details', to: 'category#house_details_create'
   patch 'category/house_details/:id', to: 'category#house_details_update'
   delete 'category/house_details/:id', to: 'category#house_details_delete'



   #CRUD operations for Extra Curricular DEtails
   get 'category/extra_curricular_index', to: 'category#extra_curricular_index'
   post 'category/extra_curricular_index', to: 'category#extra_curricular_create'
   patch 'category/extra_curricular_index/:id', to: 'category#extra_curricular_update'
   delete 'category/extra_curricular_index/:id', to: 'category#extra_curricular_delete'


    # Keep the resources route at the end
    resources :category
  end