get 'other_grade/index', to: 'other_grade#index'

get 'other_grade/show_other_grades', to: 'other_grade#show_other_grades', as:'show_other_grades'

post '/other_grade/create_other_grade', to: 'other_grade#create_other_grade' , as: 'create_other_grade'

patch '/other_grade/update_other_grade/:id', to: 'other_grade#update_other_grade', as: 'update_other_grade'

delete '/other_grade/delete_other_grade/:id', to: 'other_grade#delete_other_grade', as: 'delete_other_grade'

resources :other_grade