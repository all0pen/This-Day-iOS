# Generated by Django 2.1.5 on 2019-01-15 10:31

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('thisday', '0004_auto_20190114_0610'),
    ]

    operations = [
        migrations.CreateModel(
            name='FriendsList',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('friend', models.CharField(max_length=30)),
            ],
        ),
        migrations.CreateModel(
            name='GroupInfo',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('groupName', models.CharField(max_length=100)),
                ('memberList', models.CharField(max_length=150)),
                ('FixedSchedule', models.CharField(max_length=100)),
            ],
        ),
        migrations.DeleteModel(
            name='FixedSchedule',
        ),
        migrations.DeleteModel(
            name='RecommendedList',
        ),
    ]