# Generated by Django 3.2.5 on 2024-08-14 16:19

import datetime
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('Cevital', '0002_alter_effectif_email'),
    ]

    operations = [
        migrations.AlterField(
            model_name='effectif',
            name='date_de_naissance',
            field=models.DateField(default=datetime.date.today),
        ),
    ]
