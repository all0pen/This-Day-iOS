from django.contrib import admin
from .models import *
# Register your models here.

class GroupsAdmin(admin.ModelAdmin):
    list_display = ['groupName', 'finalDate', 'fixedSchedule', 'member1', 'member2', 'member3', 'member4', 'member5', 'vote1', 'vote2', 'vote3', 'vote4', 'vote5']

admin.site.register(GroupInfo, GroupsAdmin)

class MembersAdmin(admin.ModelAdmin):
    list_display = ['member']

admin.site.register(Members, MembersAdmin)