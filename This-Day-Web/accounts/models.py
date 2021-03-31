from django.db import models

# Create your models here.

# 회원 가입 목록 (회원가입)
class Accounts(models.Model):
    userID = models.CharField(max_length=50)
    userPassword = models.CharField(max_length=50)

    def __str__(self):
        return self.userID

# 친구 추가
class Friendship(models.Model):
    user1 = models.ForeignKey(Accounts, on_delete=models.CASCADE, related_name='my_friends')
    user2 = models.ForeignKey(Accounts, on_delete=models.CASCADE, related_name='your_friends')