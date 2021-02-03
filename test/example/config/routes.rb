Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'callers/:action', controller: 'callers'
  get 'child_callers/:action', controller: 'child_callers'
  get 'callees/:action', controller: 'callees'
end
