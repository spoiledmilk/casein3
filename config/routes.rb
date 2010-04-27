Rails.application.routes.draw do |map|
  map.connect '/casein', :controller => 'casein/auth'
end