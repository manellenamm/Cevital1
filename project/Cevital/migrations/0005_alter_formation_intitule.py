# Generated by Django 3.2.5 on 2024-08-14 16:27

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('Cevital', '0004_alter_effectif_email'),
    ]

    operations = [
        migrations.AlterField(
            model_name='formation',
            name='intitule',
            field=models.CharField(max_length=255),
        ),
    ]