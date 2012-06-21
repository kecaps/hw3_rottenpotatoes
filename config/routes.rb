Rottenpotatoes::Application.routes.draw do
  resources :movies
  
  match '/movies/similar_to/:id' => "movies#similar_to"
   
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
end
