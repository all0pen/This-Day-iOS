# Generated by Django 2.1.5 on 2019-01-18 08:46

from django.db import migrations, models
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('thisday', '0012_auto_20190118_0548'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='groupinfo',
            name='voteList',
        ),
        migrations.AddField(
            model_name='groupinfo',
            name='vote1',
            field=models.DateTimeField(blank=True, default=django.utils.timezone.now),
        ),
        migrations.AddField(
            model_name='groupinfo',
            name='vote2',
            field=models.DateTimeField(blank=True, default=django.utils.timezone.now),
        ),
        migrations.AddField(
            model_name='groupinfo',
            name='vote3',
            field=models.DateTimeField(blank=True, default=django.utils.timezone.now),
        ),
        migrations.AddField(
            model_name='groupinfo',
            name='vote4',
            field=models.DateTimeField(blank=True, default=django.utils.timezone.now),
        ),
        migrations.AddField(
            model_name='groupinfo',
            name='vote5',
            field=models.DateTimeField(blank=True, default=django.utils.timezone.now),
        ),
        migrations.DeleteModel(
            name='VoteInfo',
        ),
    ]