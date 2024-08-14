# Generated by Django 3.2.5 on 2024-08-14 10:05

import django.core.validators
from django.db import migrations, models
import django.db.models.deletion
import uuid


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Categorie',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nom', models.CharField(max_length=50)),
            ],
        ),
        migrations.CreateModel(
            name='Dashboard',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('prevu_action_formation', models.CharField(max_length=50)),
                ('prevu_effectifs', models.CharField(max_length=50)),
                ('Plan_fromation', models.CharField(max_length=50)),
                ('Plan_effectifs', models.IntegerField()),
                ('mois', models.IntegerField(choices=[(1, 'Janvier'), (2, 'Février'), (3, 'Mars'), (4, 'Avril'), (5, 'Mai'), (6, 'Juin'), (7, 'Juillet'), (8, 'Août'), (9, 'Septembre'), (10, 'Octobre'), (11, 'Novembre'), (12, 'Décembre')])),
                ('annee', models.IntegerField()),
            ],
        ),
        migrations.CreateModel(
            name='Datee',
            fields=[
                ('id_date', models.AutoField(primary_key=True, serialize=False)),
                ('date', models.DateField()),
            ],
        ),
        migrations.CreateModel(
            name='Effectif',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nom', models.CharField(max_length=50)),
                ('prenom', models.CharField(max_length=50)),
                ('date_de_naissance', models.DateField()),
                ('matricule', models.CharField(max_length=50, unique=True)),
                ('structure', models.CharField(max_length=50)),
                ('service', models.CharField(max_length=50)),
                ('email', models.EmailField(blank=True, default='pas_d_email@example.com', max_length=254, null=True, unique=True)),
                ('fonction', models.CharField(max_length=50)),
                ('pole', models.CharField(max_length=50)),
                ('csp', models.CharField(choices=[('cadre', 'Cadre'), ('maitrise', 'Maitrise'), ('execution', 'Exécution')], max_length=50)),
            ],
        ),
        migrations.CreateModel(
            name='Evaluateur',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nom', models.CharField(max_length=50)),
                ('prenom', models.CharField(max_length=50)),
                ('date_de_naissance', models.DateField()),
                ('matricule', models.CharField(max_length=50, unique=True)),
            ],
        ),
        migrations.CreateModel(
            name='Formateur',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nom', models.CharField(max_length=50)),
                ('prenom', models.CharField(max_length=50)),
                ('date_de_naissance', models.DateField()),
                ('matricule', models.CharField(max_length=50, unique=True)),
            ],
        ),
        migrations.CreateModel(
            name='Formation',
            fields=[
                ('id_formation', models.AutoField(primary_key=True, serialize=False)),
                ('intitule', models.CharField(max_length=50)),
                ('formateur', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='Cevital.formateur')),
            ],
        ),
        migrations.CreateModel(
            name='Orienter',
            fields=[
                ('id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('organisme_formation', models.CharField(max_length=50)),
                ('code_tiers', models.CharField(max_length=50)),
                ('lieu_formation', models.CharField(max_length=50)),
                ('type_formation', models.CharField(max_length=50)),
                ('categorie_formation', models.CharField(choices=[('métier', 'Métier'), ('ordre_légal', 'Ordre légal'), ('qualité', 'Qualité'), ('transverse', 'Transverse')], max_length=50)),
                ('cout_total', models.CharField(max_length=50)),
                ('NumBc', models.CharField(max_length=50)),
                ('Facture_Pédagogique', models.CharField(max_length=50)),
                ('NuméroFacture_Pédagogique', models.CharField(max_length=50)),
                ('Organisme_logistque', models.CharField(max_length=50)),
                ('Facture_Hotel', models.CharField(max_length=50)),
                ('cout_logistique', models.CharField(max_length=50)),
                ('Enjeu', models.CharField(max_length=50)),
                ('date_debut', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='orienter_date_debut', to='Cevital.datee')),
                ('date_fin', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='orienter_date_fin', to='Cevital.datee')),
                ('formation', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='Cevital.formation')),
            ],
        ),
        migrations.CreateModel(
            name='Responsable_hiearchique',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nom', models.CharField(max_length=50)),
                ('prenom', models.CharField(max_length=50)),
                ('date_de_naissance', models.DateField()),
                ('matricule', models.CharField(max_length=50, unique=True)),
                ('email', models.EmailField(max_length=254, unique=True)),
            ],
        ),
        migrations.CreateModel(
            name='SousGroupe',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nom', models.CharField(max_length=50)),
                ('participants', models.ManyToManyField(to='Cevital.Effectif')),
            ],
        ),
        migrations.CreateModel(
            name='ParticipantFormation',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('presence', models.BooleanField(default=False)),
                ('etat', models.CharField(max_length=50)),
                ('orientation', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='Cevital.orienter')),
                ('participant', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='Cevital.effectif')),
            ],
        ),
        migrations.AddField(
            model_name='orienter',
            name='responsable_hiearchique',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='Cevital.responsable_hiearchique'),
        ),
        migrations.AddField(
            model_name='orienter',
            name='sous_groupe',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='Cevital.sousgroupe'),
        ),
        migrations.CreateModel(
            name='Evaluerfroid',
            fields=[
                ('evaluation_id', models.AutoField(primary_key=True, serialize=False)),
                ('date', models.DateField()),
                ('recours', models.TextField()),
                ('besoin', models.TextField()),
                ('precision', models.TextField()),
                ('objectif', models.TextField()),
                ('rate_besoin', models.IntegerField(validators=[django.core.validators.MinValueValidator(1), django.core.validators.MaxValueValidator(5)])),
                ('rate_objectif', models.IntegerField(validators=[django.core.validators.MinValueValidator(1), django.core.validators.MaxValueValidator(5)])),
                ('rate_connaissance', models.IntegerField(validators=[django.core.validators.MinValueValidator(1), django.core.validators.MaxValueValidator(5)])),
                ('rate_reduction_risque', models.IntegerField(validators=[django.core.validators.MinValueValidator(1), django.core.validators.MaxValueValidator(5)])),
                ('rate_maitrise_metier', models.IntegerField(validators=[django.core.validators.MinValueValidator(1), django.core.validators.MaxValueValidator(5)])),
                ('taux_satisfaction', models.CharField(max_length=50)),
                ('evaluateur', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='Cevital.evaluateur')),
                ('orienter', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='Cevital.orienter')),
                ('participant', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='Cevital.effectif')),
            ],
            options={
                'verbose_name': 'Évaluation à froid',
                'verbose_name_plural': 'Évaluations à froid',
            },
        ),
        migrations.CreateModel(
            name='Evaluerchaud',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('date_evaluation', models.DateField()),
                ('objectifs', models.CharField(max_length=100)),
                ('contenu', models.CharField(max_length=100)),
                ('equilibre', models.CharField(max_length=100)),
                ('documentation', models.CharField(max_length=100)),
                ('methodes', models.CharField(max_length=100)),
                ('communication', models.CharField(max_length=100)),
                ('adaptation', models.CharField(max_length=100)),
                ('participation', models.CharField(max_length=100)),
                ('interet', models.CharField(max_length=100)),
                ('duree', models.CharField(max_length=100)),
                ('local', models.CharField(max_length=100)),
                ('moyens', models.CharField(max_length=100)),
                ('comprehension', models.CharField(max_length=100)),
                ('applicables', models.CharField(max_length=100)),
                ('satisfaction', models.CharField(max_length=100)),
                ('recommendation', models.CharField(max_length=100)),
                ('evaluateur', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='Cevital.evaluateur')),
                ('orienter', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='Cevital.orienter')),
            ],
        ),
        migrations.CreateModel(
            name='Dashboardbudjets',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('realise', models.CharField(max_length=50)),
                ('Prevu', models.CharField(max_length=50)),
                ('Plan', models.CharField(max_length=50)),
                ('mois', models.IntegerField(choices=[(1, 'Janvier'), (2, 'Février'), (3, 'Mars'), (4, 'Avril'), (5, 'Mai'), (6, 'Juin'), (7, 'Juillet'), (8, 'Août'), (9, 'Septembre'), (10, 'Octobre'), (11, 'Novembre'), (12, 'Décembre')])),
                ('annee', models.IntegerField()),
            ],
            options={
                'unique_together': {('realise', 'Prevu', 'mois', 'annee')},
            },
        ),
        migrations.AlterUniqueTogether(
            name='orienter',
            unique_together={('formation', 'date_debut', 'date_fin', 'sous_groupe')},
        ),
    ]
