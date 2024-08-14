from django.contrib import admin

# Register your models here.

from .models import *

admin.site.register(Effectif)
admin.site.register(Orienter)
admin.site.register(Formateur)
admin.site.register(Datee)
admin.site.register(Evaluerfroid)
admin.site.register(Evaluerchaud)
admin.site.register(Categorie)
admin.site.register(SousGroupe)
admin.site.register(Evaluateur)
admin.site.register(ParticipantFormation)
admin.site.register(Responsable_hiearchique)
admin.site.register(Dashboardbudjets)
admin.site.register(Dashboard)


class FormationAdmin(admin.ModelAdmin):
    list_display = ('id_formation', 'intitule', 'formateur')  # Specify the fields to display

# Register the Formation model with the custom admin class
admin.site.register(Formation, FormationAdmin)