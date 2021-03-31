from django.shortcuts import render

# Create your views here.

# API 교환 뷰
from rest_framework.generics import *
from .serializers import *
from .models import Friendship, Accounts

class FriendListAPI(ListCreateAPIView):
    queryset = Friendship.objects.all()
    serializer_class = FriendSerializer

class AccountListAPI(ListCreateAPIView):
    queryset = Accounts.objects.all()
    serializer_class = AccountsSerializer
