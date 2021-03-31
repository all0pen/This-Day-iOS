from django.contrib import admin
from .models import *

# Register your models here.

class AccountsAdmin(admin.ModelAdmin):
    list_display = ['id', 'userID', 'userPassword']

admin.site.register(Accounts, AccountsAdmin)

class FriendsAdmin(admin.ModelAdmin):
    list_display = ['user1', 'user2']

admin.site.register(Friendship, FriendsAdmin)