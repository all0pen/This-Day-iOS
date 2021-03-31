from django.urls import path
from .views import *

urlpatterns = [
    path('mycalendar_get/', mycalendar_fetch),
    path('mycalendar_post/', mycalendar_save),
    path('calendar/list/', MyCalendarListAPI.as_view()),
]