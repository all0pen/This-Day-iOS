from .models import *
from rest_framework import serializers

class GroupInfoSerializer(serializers.ModelSerializer):
    # 어떤 모델을 시리얼라이저할 건지
    class Meta:
        model = GroupInfo
        fields = '__all__'