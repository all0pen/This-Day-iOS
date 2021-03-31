from rest_framework import serializers

from .models import Friendship, Accounts
class FriendSerializer(serializers.ModelSerializer):
    class Meta:
        model = Friendship
        fields = '__all__'

class AccountsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Accounts
        fields = '__all__'