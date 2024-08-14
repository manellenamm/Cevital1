"""Django_project URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import path, include
from django.urls import re_path
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)
from Cevital.views import *

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('rest_framework.urls')),
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
     path('api/login/', UserLoginAPIView.as_view(), name='user-login'),
      path('api/register/', RegisterView.as_view(), name='register'),
     path('api/orienter/create/', OrienterCreateAPIView.as_view(), name='orienter-create'),
    path('api/orienter/list/',OrienterList.as_view(), name='orienter-list'),
     path('api/orientation/<uuid:pk>/participants/', OrientationParticipantsView.as_view(), name='orientation-participants'),
     path('api/orienter/', create_orienter, name='orienter-create'),
      path('api/groupe/', Sous_groupeDetail.as_view(), name='orienter-list'),
     path('api/responsable/create/', responsableCreateAPIView.as_view(), name='responsable-create'),
     path('api/participant_formation/create/', ParticipantformCreateAPIView.as_view(), name='responsable-create'),
     path('api/responsable/', ResponsableDetail.as_view(), name='Responable-list'),
     path('responsable_hiearchique/<int:pk>/update/', ResponsableHiearchiqueUpdateView.as_view(), name='responsable_hiearchique-update'),
    path('responsable_hiearchique/<int:pk>/delete/', ResponsableHiearchiqueDeleteView.as_view(), name='responsable_hiearchique-delete'),
     path('api/orienter/delete/', OrienterDeleteAPIView.as_view(), name='orienter-delete'),
     path('api/formateur/create/',FormateurCreateAPIView.as_view(), name='formateur-create'),
     path('formateur/<int:pk>/update/', FormateurUpdateView.as_view(), name='formateur-update'),
    path('formateur/<int:pk>/delete/', FormateurDeleteView.as_view(), name='formateur-delete'),
     path('api/formation/create/',FormationCreateAPIView.as_view(), name='formation-create'),
      path('formation/<int:pk>/update/', FormationUpdateView.as_view(), name='formation-update'),
    path('formation/<int:pk>/delete/', FormationDeleteView.as_view(), name='formation-delete'),
     path('api/formation/',FormationDetail.as_view(), name='formation-list'),
     path('sousgroupe/<int:pk>/update/', SousGroupeUpdateView.as_view(), name='sousgroupe-update'),
    path('sousgroupe/<int:pk>/delete/', SousGroupeDeleteView.as_view(), name='sousgroupe-delete'),
     path('api/effectif/create/',EffectifCreateAPIView.as_view(), name='effectif-create'),
     path('api/effectif/<int:matricule>/', get_effectif, name='get_effectif'),
      path('orienter/<uuid:pk>/update/', OrienterUpdateView.as_view(), name='orienter-update'),
    path('orienter/<uuid:pk>/delete/', OrienterDeleteView.as_view(), name='orienter-delete'),
    path('api/effectif/update/<int:matricule>/', update_effectif, name='update_effectif'),
    path('api/effectif/delete/<int:matricule>/', delete_effectif, name='delete_effectif'),
     path('formateur/update/<str:matricule>/', update_formateur, name='update_formateur'),
    path('formateur/delete/<int:matricule>/', delete_formateur, name='delete_formateur'),
    path('api/formateur/<int:matricule>/', get_formateur, name='get_formateur'),
    path('responsable/<str:matricule>/', get_responsable_hierarchique, name='get_responsable_hierarchique'),
    path('responsable/<int:matricule>/delete/',delete_responsable_hierarchique, name='delete_responsable_hierarchique'),
    path('responsable/<int:matricule>/update/', update_responsable_hierarchique, name='update_responsable_hierarchique'),
     path('api/evaluerfroid/create/',EvaluationfroidAPIView.as_view(), name='evaluationfroide-create'),
     path('evaluerfroid/',submit_froid, name='evaluationfroide'),
     path('api/evaluerchaud/create/',EvaluationchaudAPIView.as_view(), name='evaluationchaude-create'),
     path('api/evaluateur/create/',EvaluateurCreateAPIView.as_view(), name='evaluateur-create'),
     path('api/date/create/',DateCreateAPIView.as_view(), name='date-create'),
     path('effectif/', EffectifDetail.as_view(), name='effectif-detail'),
     path('api/categorie/create/',CategorieCreateAPIView.as_view(), name='Categorie-create'),
     path('categorie/<int:pk>/update/', CategorieUpdateView.as_view(), name='categorie-update'),
    path('categorie/<int:pk>/delete/', CategorieDeleteView.as_view(), name='categorie-delete'),
     path('api/dashboard/create/',DashboardCreateAPIView.as_view(), name='Dasboard-create'),
     path('api/dashboardbudjet/create/',DashboardBudjetCreateAPIView.as_view(), name='Dasboardbudjet-create'),
     path('api/groupe/create/',SousgroupeCreateAPIView.as_view(), name='groupe-create'),
    path('api/evaluerchaud',EvaluerchaudViewSet , name='evaluerchaud'),
     path('formation/<str:matricule>/', OrienterDetailView.as_view(), name='formation-details'),
    path('formateurs/',  FormateurList.as_view(), name='formateur-list'), 
    path('evaluateur/<str:matricule>/', EvaluateurDetail.as_view(), name='Evaluateur-details'),
    re_path(r'^api/delete-participant-formation/(?P<participant_id>\d+)/(?P<orientation_id>[0-9a-fA-F-]{36})/$', delete_ParticipantFormation, name='delete_participant_formation'),
    path('dashboard-update/', DashboardUpdateView , name='dashboard_update'),
    path('dashboardBudjet-update/', DashboardBudjetUpdateView, name='dashboard-budjet-update'),
     path('dashboard-delete/<int:mois>/<int:annee>/', delete_dashboard, name='delete_dashboard'),
      path('dashboardbudjet-delete/<int:mois>/<int:annee>/', delete_dashboardBudjets, name='delete_dashboard'),
    path('api/filter-dashbaord/',filter_dashboard , name='filter_budjets'),
    path('api/filter-participant-formation/', filter_participant_formation, name='filter_participant_formation'),
    # Routes pour Evaluateur
    path('evaluateur/<int:pk>/update/', EvaluateurUpdateView.as_view(), name='evaluateur-update'),
    path('evaluateur/<int:pk>/delete/', EvaluateurDeleteView.as_view(), name='evaluateur-delete'),
    path('send-form-email/', send_form_email, name='send_form_email'),
     path('submitform/', submit_form, name='submit_form'), 
     path('submitformsansemail/', submit_form_sans_email, name='submit_form_sans_email'), 
     path('submit/',submit_forms, name='submit_forms'),
     path('tableau_data/', tableau_data, name='submit'),
     path('envoyer-evaluations/', envoyer_evaluations, name='envoyer_evaluations'),
     path('orientations/<str:id>/', get_orientation_details, name='get_orientation_details'),
    path('all-data/', get_all_data, name='get_all_data'),
     path('get_participant_id/', get_participant_id, name='get_participant_id'),
     path('filter/', FilterByCriteriaView.as_view(), name='filter_by_structure_pole'),
     path('participants/<uuid:orientation_id>/', ParticipantsByOrientationView.as_view(), name='participants-by-orientation'),
    path('count_formations/', count_formations, name='count_formations'),
    path('api/filter-budjets/',filter_budgets , name='filter_budjets'),
    path('api/update-participant-formation/', ParticipantFormationUpdateView, name='update_participant_formation'),
    path('participants-with-default-email/', participants_with_default_email, name='participants_with_default_email'),
    path('api/formation/<str:intitule>/', get_formation_by_intitule, name='get_formation_by_intitule'),
    path('api/update-formation/<str:intitule>/', update_formation, name='update_formation'),
    path('api/delete-formation/<str:intitule>/', delete_formation, name='delete_formation'),
    path('api/sous-groupe/<str:nom_sous_groupe>/', participants_sous_groupe_json, name='participants_sous_groupe_json'),


    
    ]
if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
