from django.urls import path
from . import views

app_name = 'profilepage'

urlpatterns = [
    path('profile/', views.show_profile, name='show_profile'),
    path('profile/update/', views.update_profile, name='update_profile'),
    path('change_password/', views.change_password, name='change_password'),
]
