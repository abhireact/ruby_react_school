get 'scholastic_grade/index', to: 'scholastic_grade#index'

get 'scholastic_grade/show_scholastic_grades', to: 'scholastic_grade#show_scholastic_grades', as:'show_scholastic_grades'

post '/scholastic_grade/create_scholastic_grade', to: 'scholastic_grade#create_scholastic_grade' , as: 'create_scholastic_grade'

patch '/scholastic_grade/update_scholastic_grade/:id', to: 'scholastic_grade#update_scholastic_grade', as: 'update_scholastic_grade'

delete '/scholastic_grade/delete_scholastic_grade/:id', to: 'scholastic_grade#delete_scholastic_grade', as: 'delete_scholastic_grade'

resources :scholastic_grade