# Generated by Django 3.2.5 on 2024-08-14 16:22

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('Cevital', '0003_alter_effectif_date_de_naissance'),
    ]

    operations = [
        migrations.AlterField(
            model_name='effectif',
            name='email',
            field=models.EmailField(default='pas_d_email@example.com', max_length=254),
        ),
    ]
