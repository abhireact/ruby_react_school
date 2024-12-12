get 'other_particular/index', to: 'other_particular#index'

post '/other_particular/co_scholastic_create', to: 'other_particular#co_scholastic_create', as: 'co_scholastic_create'

post '/other_particular/co_scholastic_component_create', to: 'other_particular#co_scholastic_component_create', as: 'co_scholastic_component_create'

patch '/other_particular/co_scholastic_update/:id', to: 'other_particular#co_scholastic_update', as: 'co_scholastic_update'

delete '/other_particular/delete_particular/:id', to: 'other_particular#delete_particular', as: 'delete_particular'

delete '/other_particular/delete_component/:id', to: 'other_particular#delete_component', as: 'delete_component'
patch '/other_particular/co_scholastic_component_update/:id', to: 'other_particular#co_scholastic_component_update', as: 'co_scholastic_component_update'

resources :other_particular
