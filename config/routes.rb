# frozen_string_literal: true

Kenui::Engine.routes.draw do
  root to: 'email_notifications#index'

  resources :email_notifications, only: [:index]

  scope '/email_notifications' do
    get '/pagination' => 'email_notifications#pagination', :as => 'email_notification_pagination'
    get '/configuration' => 'email_notifications#configuration', :as => 'email_notifications_get_configuration'
    post '/configuration' => 'email_notifications#set_configuration', :as => 'email_notifications_configuration'
    get '/events_to_consider' => 'email_notifications#events_to_consider', :as => 'email_notification_events_to_consider'
  end
end
