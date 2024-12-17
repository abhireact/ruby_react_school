get 'exam_report_releases/index', to: 'exam_report_releases#index'
post '/exam_report_releases/exam_report_releases_data', to: 'exam_report_releases#exam_report_releases_data', as: 'exam_report_releases_data'

resources :exam_report_releases