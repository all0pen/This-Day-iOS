from django.urls import path
from .views import *

urlpatterns = [
    path('friend/list/',FriendListAPI.as_view()),
    path('account/list/', AccountListAPI.as_view()),
]