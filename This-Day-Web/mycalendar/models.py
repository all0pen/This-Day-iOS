from django.db import models
from django.contrib.auth import get_user_model
# Create your models here.

class CalendarInfo(models.Model):
    title = models.CharField(max_length=100)
    memo = models.TextField(blank=True)
    date = models.DateField()
    userID = models.ForeignKey(get_user_model(), on_delete=models.CASCADE, related_name='todos')