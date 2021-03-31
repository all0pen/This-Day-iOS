# Generated by Django 2.1.5 on 2019-01-18 05:48

from django.db import migrations, models
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('thisday', '0011_auto_20190117_0747'),
    ]

    operations = [
        migrations.AlterField(
            model_name='groupinfo',
            name='fixedSchedule',
            field=models.DateTimeField(blank=True, default=django.utils.timezone.now),
        ),
        migrations.AlterField(
            model_name='groupinfo',
            name='memberList',
            field=models.ManyToManyField(blank=True, to='thisday.Members'),
        ),
        migrations.AlterField(
            model_name='groupinfo',
            name='voteList',
            field=models.ManyToManyField(blank=True, to='thisday.VoteInfo'),
        ),
    ]