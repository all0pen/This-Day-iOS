from django.shortcuts import render

# Create your views here.
from .models import CalendarInfo
from django.http import JsonResponse

def mycalendar_fetch(request):
    calendars = CalendarInfo.objects.all() # 데이터 싹 다 가져오기
    calendar_list = [] # json 파일로 변환하기 위한 배열 만듦
    for index,calendar in enumerate(calendars, start=1):
        # start에 지정한 번호부터 주는 것
        calendar_list.append({'title':calendar.title, 'memo':calendar.memo, 'date':calendar.date, 'userID':calendar.userID.id})

    return JsonResponse(calendar_list, safe=False)

import json
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST

@csrf_exempt
@require_POST
def mycalendar_save(request):
    received_json_data = {}
    if request.body:
        received_json_data = json.loads(request.body.decode("utf-8"))
        title = received_json_data['title']
        memo = received_json_data['memo']
        date = received_json_data['date']
        userID = received_json_data['userID']

        newCalendarInfo = CalendarInfo.objects.create(title=title, memo=memo, date=date, userID=userID)
        newCalendarInfo.save()

    return JsonResponse(received_json_data) # 넘어온 데이터를 그대로 보여주는 형태


# API 교환 뷰
from rest_framework import generics
from .serializers import MyCalendarSerializer
from django_filters.rest_framework import DjangoFilterBackend

class MyCalendarListAPI(generics.ListCreateAPIView):
    queryset = CalendarInfo.objects.all()
    serializer_class = MyCalendarSerializer
    filter_backends = (DjangoFilterBackend,)
    filter_fields = ('date',)