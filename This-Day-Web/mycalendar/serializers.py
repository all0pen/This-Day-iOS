from .models import CalendarInfo
from rest_framework import serializers

class MyCalendarSerializer(serializers.ModelSerializer):
    # 어떤 모델을 시리얼라이저할 건지
    class Meta:
        model = CalendarInfo
        fields = '__all__'