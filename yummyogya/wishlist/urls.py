from django.urls import path
from . import views

app_name = 'wishlist'

urlpatterns = [
    path('add/<int:food_id>/', views.add_to_wishlist, name='add_to_wishlist'),
    path('wishlist/', views.view_wishlist, name='view_wishlist'),
    path('wishlist/json/', views.get_wishlist_json, name='wishlist_json'), # url get json
    path('wishlist/remove-from-wishlist/<int:food_id>/', views.remove_from_wishlist, name='remove_from_wishlist'),
]