# details/urls.py
from django.urls import path

from . import views

app_name = 'details'

urlpatterns = [
    path('details/<int:id>/', views.food_detail, name='food_detail'),
    path('details_flutter/', views.food_detail_flutter_query, name='food_detail_flutter_query'),
    path('add_review/', views.add_review, name='add_review'),
]
