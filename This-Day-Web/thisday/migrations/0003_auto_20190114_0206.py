# Generated by Django 2.1.5 on 2019-01-14 02:06

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('thisday', '0002_fixedschedule_recommendedlist'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='calendar',
            name='month',
        ),
        migrations.RemoveField(
            model_name='calendar',
            name='time',
        ),
        migrations.RemoveField(
            model_name='calendar',
            name='year',
        ),
        migrations.RemoveField(
            model_name='fixedschedule',
            name='month',
        ),
        migrations.RemoveField(
            model_name='fixedschedule',
            name='year',
        ),
        migrations.RemoveField(
            model_name='recommendedlist',
            name='month',
        ),
        migrations.RemoveField(
            model_name='recommendedlist',
            name='year',
        ),
    ]