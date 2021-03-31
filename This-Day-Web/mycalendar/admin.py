from django.contrib import admin
from .models import CalendarInfo
# Register your models here.

class CalendarInfoAdmin(admin.ModelAdmin):
    list_display = ['title', 'date', 'memo', 'userID']

admin.site.register(CalendarInfo, CalendarInfoAdmin)