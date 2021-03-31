from django.urls import path
from .views import *

urlpatterns = [
    path('group_get/', groups_fetch),
    path('group_post/', groups_save),
    path('group/list/', GroupInfoListAPI.as_view()),
]