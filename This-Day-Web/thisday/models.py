from django.db import models
from django.contrib.auth import get_user_model
from django.utils import timezone
from accounts.models import *
# Create your models here.

class Members(models.Model):
    member = models.ForeignKey(Friendship, on_delete=models.CASCADE, related_name='my_friends', default=0)

class GroupInfo(models.Model):
    groupName = models.CharField(max_length=100)
    member1 = models.ForeignKey(Accounts, on_delete=models.CASCADE, related_name='member1', default=0)
    member2 = models.ForeignKey(Accounts, on_delete=models.CASCADE, related_name='member2', default=0)
    member3 = models.ForeignKey(Accounts, on_delete=models.CASCADE, related_name='member3', default=0)
    member4 = models.ForeignKey(Accounts, on_delete=models.CASCADE, related_name='member4', default=0)
    member5 = models.ForeignKey(Accounts, on_delete=models.CASCADE, related_name='member5', default=0)
    vote1 = models.DateField(default=timezone.now, blank=True)
    vote2 = models.DateField(default=timezone.now, blank=True)
    vote3 = models.DateField(default=timezone.now, blank=True)
    vote4 = models.DateField(default=timezone.now, blank=True)
    vote5 = models.DateField(default=timezone.now, blank=True)
    finalDate = models.DateField(default=timezone.now, blank=True)
    fixedSchedule = models.DateField(default=timezone.now, blank=True)

    def __str__(self):
        return self.groupName