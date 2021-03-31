from django.shortcuts import render

# Create your views here.
from .models import *
from django.http import JsonResponse

def groups_fetch(request):
    groups = GroupInfo.objects.all()
    groups_list = []
    for index, group in enumerate(groups, start=1):
        groups_list.append({'index':index, 'groupName':group.groupName, 'memberList':group.memberList, 'fixedSchedule':group.fixedSchedule})

    return JsonResponse(groups_list, safe=False)

import json
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST

@csrf_exempt
@require_POST

def groups_save(request):
    if request.body:
        received_json_data = json.loads(request.body.decode("utf-8"))
        groupName = received_json_data['groupName']
        memberList = received_json_data['memberList']
        fixedSchedule = received_json_data['fixedSchedule']

        newgroupInfo = GroupInfo.objects.create(groupName=groupName, memberList=memberList, fixedSchedule=fixedSchedule)
        newgroupInfo.save()

    return JsonResponse(received_json_data)


# API 교환 뷰
from rest_framework import generics
from .serializers import *

class GroupInfoListAPI(generics.ListCreateAPIView):
    queryset = GroupInfo.objects.all()
    serializer_class = GroupInfoSerializer