from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from Cevital.serializers import *
from rest_framework import generics
from .models import *
from django.shortcuts import get_object_or_404, redirect
from django.views import View
from django.utils import timezone
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
from django.core.mail import EmailMessage
from django.template.loader import render_to_string
from datetime import date
from django.shortcuts import render
from rest_framework import viewsets
from datetime import timedelta
from django.core.mail import send_mail




class UserLoginAPIView(APIView):
    serializer_class = UserLoginSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        # Vous pouvez personnaliser la réponse en fonction de vos besoins
        return Response({'message': 'Login successful', 'user_id': user.id}, status=status.HTTP_200_OK)
    


class OrienterCreateAPIView(generics.CreateAPIView):
    queryset = Orienter.objects.all()
    serializer_class = OrienterSerializer

    def perform_create(self, serializer):
        serializer.save()


class DateCreateAPIView(generics.CreateAPIView):
    queryset = Datee.objects.all()
    serializer_class = DateeSerializer

    def perform_create(self, serializer):
        serializer.save()

class OrienterDeleteAPIView(generics.CreateAPIView):
    queryset = Orienter.objects.all()
    serializer_class = OrienterSerializer

    def perform_create(self, serializer):
        serializer.Delete()

from django.views.decorators.http import require_POST
@csrf_exempt
@require_POST
def create_orienter(request):
    try:
        # Parse le corps de la requête
        data = json.loads(request.body)

        # Enregistre les dates dans le modèle Datee
        date_debut, created = Datee.objects.get_or_create(date=data['date_debut'])
        date_fin, created = Datee.objects.get_or_create(date=data['date_fin'])

        # Crée un enregistrement dans le modèle Orienter
        orienter = Orienter.objects.create(
            sous_groupe_id=data['sous_groupe'],
            formation_id=data['formation'],
            date_debut=date_debut,
            date_fin=date_fin,
            organisme_formation=data['organisme_formation'],
            code_tiers=data['code_tiers'],
            lieu_formation=data['lieu_formation'],
            type_formation=data['type_formation'],
            categorie_formation=data['categorie_formation'],
            responsable_hiearchique_id=data['responsable_hiearchique'],
            cout_total=data['cout_total'],
            NumBc=data['NumBc'],
            Facture_Pédagogique=data['Facture_Pédagogique'],
            NuméroFacture_Pédagogique=data['NuméroFacture_Pédagogique'],
            Organisme_logistque=data['Organisme_logistque'],
            Facture_Hotel=data['Facture_Hotel'],
            cout_logistique=data['cout_logistique'],
            Enjeu=data['Enjeu']
        )

        return JsonResponse({'status': 'success', 'id': orienter.id}, status=201)
    except KeyError as e:
        return JsonResponse({'error': f'Missing key: {str(e)}'}, status=400)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
    

class FormateurCreateAPIView(generics.CreateAPIView):
    queryset = Formateur.objects.all()
    serializer_class = FormateurSerializer

    def perform_create(self, serializer):
        serializer.save()

class FormationCreateAPIView(generics.CreateAPIView):
    queryset = Formation.objects.all()
    serializer_class = FormationSerializer

    def perform_create(self, serializer):
        serializer.save()


class EffectifCreateAPIView(generics.CreateAPIView):
    queryset = Effectif.objects.all()
    serializer_class = EffectifSerializer

    def perform_create(self, serializer):
        serializer.save()

from django.http import JsonResponse, HttpResponseNotFound
@csrf_exempt
def update_effectif(request, matricule):
    if request.method == 'PUT':
        data = json.loads(request.body)
        effectif = get_object_or_404(Effectif, matricule=matricule)
        
        for key, value in data.items():
            setattr(effectif, key, value)
        
        effectif.save()
        return JsonResponse({'message': 'Effectif mis à jour avec succès'}, status=200)
    else:
        return HttpResponseNotFound('Méthode non autorisée')

@csrf_exempt
def delete_effectif(request, matricule):
    if request.method == 'DELETE':
        effectif = get_object_or_404(Effectif, matricule=matricule)
        effectif.delete()
        return JsonResponse({'message': 'Effectif supprimé avec succès'}, status=200)
    else:
        return HttpResponseNotFound('Méthode non autorisée')

def get_effectif(request, matricule):
    effectif = get_object_or_404(Effectif, matricule=matricule)
    data = {
        'nom': effectif.nom,
        'prenom': effectif.prenom,
        'date_de_naissance': effectif.date_de_naissance,
        'matricule': effectif.matricule,
        'structure': effectif.structure,
        'service': effectif.service,
        'email': effectif.email,
        'fonction': effectif.fonction,
        'pole': effectif.pole,
        'csp': effectif.csp,
    }
    return JsonResponse(data)



@csrf_exempt
def update_formateur(request, matricule):
    if request.method == 'PUT':
        data = json.loads(request.body)
        formateur = get_object_or_404(Formateur, matricule=matricule)
        
        for key, value in data.items():
            setattr(formateur, key, value)
        
        formateur.save()
        return JsonResponse({'message': 'Formateur mis à jour avec succès'}, status=200)
    else:
        return HttpResponseNotFound('Méthode non autorisée')
    

@csrf_exempt
def delete_formateur(request, matricule):
    if request.method == 'DELETE':
        formateur = get_object_or_404(Formateur, matricule=matricule)
        formateur.delete()
        return JsonResponse({'message': 'Formateur supprimé avec succès'}, status=200)
    else:
        return HttpResponseNotFound('Méthode non autorisée')
    

def get_formateur(request, matricule):
    formateur = get_object_or_404(Formateur, matricule=matricule)
    data = {
        'nom': formateur.nom,
        'prenom': formateur.prenom,
        'date_de_naissance': formateur.date_de_naissance,
        'matricule': formateur.matricule,
    }
    return JsonResponse(data)
    

def get_responsable_hierarchique(request, matricule):
    responsable = get_object_or_404(Responsable_hiearchique, matricule=matricule)
    data = {
        'nom': responsable.nom,
        'prenom': responsable.prenom,
        'date_de_naissance': responsable.date_de_naissance,
        'matricule': responsable.matricule,
        'email': responsable.email,
    }
    return JsonResponse(data)
@csrf_exempt
def delete_responsable_hierarchique(request, matricule):
    if request.method == 'DELETE':
        responsable = get_object_or_404(Responsable_hiearchique, matricule=matricule)
        responsable.delete()
        return JsonResponse({'message': 'Responsable hiérarchique supprimé avec succès'}, status=200)
    else:
        return HttpResponseNotFound('Méthode non autorisée')
    


@csrf_exempt
def update_responsable_hierarchique(request, matricule):
    if request.method == 'PUT':
        data = json.loads(request.body)
        responsable = get_object_or_404(Responsable_hiearchique, matricule=matricule)
        
        for key, value in data.items():
            setattr(responsable, key, value)
        
        responsable.save()
        return JsonResponse({'message': 'Responsable hiérarchique mis à jour avec succès'}, status=200)
    else:
        return HttpResponseNotFound('Méthode non autorisée')
    
class EvaluationfroidAPIView(generics.CreateAPIView):
    queryset = Evaluerfroid.objects.all()
    serializer_class = EvaluerfroidSerializer

    def perform_create(self, serializer):
        serializer.save()

class EvaluationchaudAPIView(generics.CreateAPIView):
    queryset = Evaluerchaud.objects.all()
    serializer_class = EvaluerchaudSerializer

    def perform_create(self, serializer):
        serializer.save()
        
class EvaluateurCreateAPIView(generics.CreateAPIView):
    queryset = Evaluateur.objects.all()
    serializer_class = EvaluateurSerializer

    def perform_create(self, serializer):
        serializer.save()


class CategorieCreateAPIView(generics.CreateAPIView):
    queryset = Categorie.objects.all()
    serializer_class = CategorieSerializer

    def perform_create(self, serializer):
        serializer.save()

class DashboardCreateAPIView(generics.CreateAPIView):
    queryset = Dashboard.objects.all()
    serializer_class = DashboardSerializer

    def perform_create(self, serializer):
        serializer.save()

class DashboardBudjetCreateAPIView(generics.CreateAPIView):
    queryset = Dashboardbudjets.objects.all()
    serializer_class = DashboardBudjetSerializer

    def perform_create(self, serializer):
        serializer.save()

class SousgroupeCreateAPIView(generics.CreateAPIView):
    queryset = SousGroupe.objects.all()
    serializer_class = SousgroupeSerializer

    def perform_create(self, serializer):
        serializer.save()

class responsableCreateAPIView(generics.CreateAPIView):
    queryset = Responsable_hiearchique.objects.all()
    serializer_class = ResponsableSerializer

    def perform_create(self, serializer):
        serializer.save()


class EffectifDetail(generics.ListAPIView):
    queryset = Effectif.objects.all()
    serializer_class = EffectifSerializer
   



class ParticipantformCreateAPIView(generics.CreateAPIView):
    queryset = ParticipantFormation.objects.all()
    serializer_class = ParticFormaSerializer
    def perform_create(self, serializer):
        serializer.save()


class CategorieUpdateView(generics.UpdateAPIView):
    queryset = Categorie.objects.all()
    serializer_class = CategorieSerializer

class CategorieDeleteView(generics.DestroyAPIView):
    queryset = Categorie.objects.all()
    serializer_class = CategorieSerializer
class ResponsableDetail(generics.ListAPIView):
    queryset = Responsable_hiearchique.objects.all()
    serializer_class = ResponsableSerializer

class ResponsableHiearchiqueUpdateView(generics.UpdateAPIView):
    queryset = Responsable_hiearchique.objects.all()
    serializer_class = ResponsableSerializer

class ResponsableHiearchiqueDeleteView(generics.DestroyAPIView):
    queryset = Responsable_hiearchique.objects.all()
    serializer_class = ResponsableSerializer
class Sous_groupeDetail(generics.ListAPIView):
    queryset = SousGroupe.objects.all()
    serializer_class = SousgroupeSerializer

class FormationDetail(generics.ListAPIView):
    queryset = Formation.objects.all()
    serializer_class = FormationSerializer

class FormationUpdateView(generics.UpdateAPIView):
    queryset = Formation.objects.all()
    serializer_class = FormationSerializer

class FormationDeleteView(generics.DestroyAPIView):
    queryset = Formation.objects.all()
    serializer_class = FormationSerializer
class SousGroupeUpdateView(generics.UpdateAPIView):
    queryset = SousGroupe.objects.all()
    serializer_class = SousgroupeSerializer

class SousGroupeDeleteView(generics.DestroyAPIView):
    queryset = SousGroupe.objects.all()
    serializer_class = SousgroupeSerializer
class EvaluateurDetail(generics.RetrieveAPIView):
    queryset = Evaluateur.objects.all()
    serializer_class = EvaluateurSerializer
    lookup_field = 'matricule'

class OrienterUpdateView(generics.UpdateAPIView):
    queryset = Orienter.objects.all()
    serializer_class = OrienterSerializer

class OrienterDeleteView(generics.DestroyAPIView):
    queryset = Orienter.objects.all()
    serializer_class = OrienterSerializer


# Vues pour ParticipantFormation
class ParticipantFormationUpdateView(generics.UpdateAPIView):
    queryset = ParticipantFormation.objects.all()
    serializer_class = ParticipantFormationSerializer

class ParticipantFormationDeleteView(generics.DestroyAPIView):
    queryset = ParticipantFormation.objects.all()
    serializer_class = ParticipantFormationSerializer

# Vues pour Dashboardbudjets
class DashboardbudjetsUpdateView(generics.UpdateAPIView):
    queryset = Dashboardbudjets.objects.all()
    serializer_class = DashboardBudjetSerializer

class DashboardbudjetsDeleteView(generics.DestroyAPIView):
    queryset = Dashboardbudjets.objects.all()
    serializer_class =  DashboardBudjetSerializer

# Vues pour Dashboard
class DashboardUpdateView(generics.UpdateAPIView):
    queryset = Dashboard.objects.all()
    serializer_class = DashboardSerializer



# Vues pour Evaluateur
class EvaluateurUpdateView(generics.UpdateAPIView):
    queryset = Evaluateur.objects.all()
    serializer_class = EvaluateurSerializer

class EvaluateurDeleteView(generics.DestroyAPIView):
    queryset = Evaluateur.objects.all()
    serializer_class = EvaluateurSerializer


class OrientationParticipantsView(generics.RetrieveAPIView):
    serializer_class = OrienterSerializer
    
    def get_object(self):
        orientation_id = self.kwargs['pk']
        return Orienter.objects.get(id=orientation_id)

    def get(self, request, *args, **kwargs):
        orientation = self.get_object()
        participants = orientation.sous_groupe.participants.all()
        participants_data = [
            {
                'id': participant.id,
                'nom': participant.nom,
                'prenom': participant.prenom,
                'matricule': participant.matricule,
                'email': participant.email,
            }
            for participant in participants
        ]
        return Response({'participants': participants_data})

from rest_framework import generics

class FormateurList(generics.ListAPIView):
    queryset = Formateur.objects.all()
    serializer_class = FormateurSerializer

class FormateurUpdateView(generics.UpdateAPIView):
    queryset = Formateur.objects.all()
    serializer_class = FormateurSerializer

class FormateurDeleteView(generics.DestroyAPIView):
    queryset = Formateur.objects.all()
    serializer_class = FormateurSerializer


class OrienterList(generics.ListAPIView):
    queryset = Orienter.objects.all()
    serializer_class = OrienterSerializer

class EvaluerchaudViewSet(viewsets.ModelViewSet):
    queryset = Evaluerchaud.objects.all()
    serializer_class = EvaluerchaudSerializer

class EffectifDeleteAPIView(generics.CreateAPIView):
    queryset = Effectif.objects.all()
    serializer_class = EffectifSerializer

    def perform_create(self, serializer):
        serializer.Delete()

class OrienterDetailView(generics.RetrieveAPIView):
    queryset = Orienter.objects.all()
    serializer_class = OrienterSerializer
    lookup_field = 'matricule_effectif__matricule'
    lookup_url_kwarg = 'matricule'

from django.http import HttpResponseBadRequest


@csrf_exempt
def submit_forms (request):
    orientation_id = request.GET.get('id')
    if not orientation_id:
        return HttpResponseBadRequest("Missing 'id' parameter")

    # Traitez le formulaire en fonction de l'ID de l'orientation
    context = {
        'orientation_id': orientation_id,
        # Ajoutez d'autres informations nécessaires au contexte
    }
    return render(request, 'submit.html', context)



@csrf_exempt
def submit_form(request):
    if request.method == 'POST':
        objectifs1 = request.POST.get('objectifs1')
        contenu1 = request.POST.get('contenu1')
        equilibre3 = request.POST.get('equilibre3')
        documentation4 = request.POST.get('documentation4')
        methodes5 = request.POST.get('methodes5')
        communication6 = request.POST.get('communication6')
        adaptation7 = request.POST.get('adaptation7')
        participation8 = request.POST.get('participation8')
        interet9 = request.POST.get('interet9')
        duree10 = request.POST.get('duree10')
        local11 = request.POST.get('local11')
        moyens12 = request.POST.get('moyens12')
        comprehension13 = request.POST.get('comprehension13')
        applicables14 = request.POST.get('applicables14')
        satisfaction15 = request.POST.get('satisfaction15')
        recommendation15 = request.POST.get('recommendation15')
        email = request.POST.get('email')
        date_evaluation = timezone.now().date()
        orienter_id = request.POST.get('orienter_id')
        participant = get_object_or_404(Effectif, email=email)

        # Créez ou récupérez l'évaluateur
        evaluateur, created = Evaluateur.objects.get_or_create(
            matricule=participant.matricule,
            defaults={
                'nom': participant.nom,
                'prenom': participant.prenom,
                'date_de_naissance': participant.date_de_naissance
            }
        )
       
        # Récupérez l'orientation
        orienter = get_object_or_404(Orienter, id=orienter_id)
        

        # Enregistrer les données dans votre modèle Evaluerchaud
        evaluation = Evaluerchaud(
            orienter=orienter,
            evaluateur=evaluateur,
            date_evaluation=date_evaluation,
            objectifs=objectifs1,
            contenu=contenu1,
            equilibre=equilibre3,
            documentation=documentation4,
            methodes=methodes5,
            communication=communication6,
            adaptation=adaptation7,
            participation=participation8,
            interet=interet9,
            duree=duree10,
            local=local11,
            moyens=moyens12,
            comprehension=comprehension13,
            applicables=applicables14,
            satisfaction=satisfaction15,
            recommendation=recommendation15
        )
        evaluation.save()  # Sauvegarder l'objet dans la base de données

        return JsonResponse({'message': 'Formulaire soumis avec succès'}, status=200)
    
    return JsonResponse({'error': 'Invalid request method'}, status=405)

delete_effectif

@csrf_exempt
def submit_form_sans_email(request):
    if request.method == 'POST':
        try:
            # Charger les données JSON depuis le corps de la requête
            data = json.loads(request.body)

            objectifs1 = data.get('objectifs1')
            contenu1 = data.get('contenu1')
            equilibre3 = data.get('equilibre3')
            documentation4 = data.get('documentation4')
            methodes5 = data.get('methodes5')
            communication6 = data.get('communication6')
            adaptation7 = data.get('adaptation7')
            participation8 = data.get('participation8')
            interet9 = data.get('interet9')
            duree10 = data.get('duree10')
            local11 = data.get('local11')
            moyens12 = data.get('moyens12')
            comprehension13 = data.get('comprehension13')
            applicables14 = data.get('applicables14')
            satisfaction15 = data.get('satisfaction15')
            recommendation15 = data.get('recommendation15')
            participant_id = data.get('participant_id')
            orienter_id = data.get('orienter_id')
            date_evaluation = timezone.now().date()
 
            participant = get_object_or_404(Effectif, id=participant_id)

            # Créez ou récupérez l'évaluateur
            evaluateur, created = Evaluateur.objects.get_or_create(
                matricule=participant.matricule,
                defaults={
                    'nom': participant.nom,
                    'prenom': participant.prenom,
                    'date_de_naissance': participant.date_de_naissance
                }
            )
           
            # Récupérez l'orientation
            orienter = get_object_or_404(Orienter, id=orienter_id)
            # Enregistrer les données dans votre modèle Evaluerchaud
            evaluation = Evaluerchaud(
                orienter=orienter,
                evaluateur=evaluateur,
                date_evaluation=date_evaluation,
                objectifs=objectifs1,
                contenu=contenu1,
                equilibre=equilibre3,
                documentation=documentation4,
                methodes=methodes5,
                communication=communication6,
                adaptation=adaptation7,
                participation=participation8,
                interet=interet9,
                duree=duree10,
                local=local11,
                moyens=moyens12,
                comprehension=comprehension13,
                applicables=applicables14,
                satisfaction=satisfaction15,
                recommendation=recommendation15
            )
            evaluation.save()  # Sauvegarder l'objet dans la base de données

            return JsonResponse({'message': 'Formulaire soumis avec succès'}, status=200)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON'}, status=400)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
 
    return JsonResponse({'error': 'Invalid request method'}, status=405)



def participants_with_default_email(request):
    # Obtenir la date actuelle
    today = timezone.now().date()

    # Filtrer les orientations dont la date de fin est aujourd'hui
    orientations_today = Orienter.objects.filter(date_fin__date=today)
    
    # Filtrer les participants avec l'email par défaut, dont l'orientation se termine aujourd'hui et dont la présence est True
    participants = ParticipantFormation.objects.filter(
        participant__email='pas_d_email@example.com', 
        orientation__in=orientations_today,
        presence=True
    )
    
    # Exclure les participants qui ont déjà été évalués
    # On suppose que `Evaluerchaud` a une relation avec `Orienter` et `Effectif`
    evaluated_orienter_ids = Evaluerchaud.objects.values_list('orienter_id', flat=True)
    participants_not_evaluated = participants.exclude(orientation_id__in=evaluated_orienter_ids)
    
    # Préparer les données à retourner
    data = []
    for participant_formation in participants_not_evaluated:
        participant = participant_formation.participant
        orientation = participant_formation.orientation
        
        data.append({
            'participant_id': participant.id,
            'participant_nom': participant.nom,
            'participant_prenom': participant.prenom,
            'date_debut': orientation.date_debut.date.strftime('%Y-%m-%d') if orientation.date_debut else 'Inconnue',  # Convertir en chaîne
            'date_fin': orientation.date_fin.date.strftime('%Y-%m-%d') if orientation.date_fin else 'Inconnue',      # Convertir en chaîne
            'email': participant.email,
            'date_de_naissance': participant.date_de_naissance.strftime('%Y-%m-%d') if participant.date_de_naissance else 'Inconnue',  # Convertir en chaîne
            'orienter_id': orientation.id,
            'formation': orientation.formation.intitule,
            'etat': participant_formation.etat,  # Inclure l'état si nécessaire
            'presence': participant_formation.presence,  # Inclure la présence si nécessaire
        })
    
    return JsonResponse({'participants': data}, status=200)







from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .models import Orienter, Formation, Datee
from datetime import datetime


from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt





from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .models import Datee, Formation, Orienter, ParticipantFormation


@csrf_exempt
def count_formations(request):
    mois = request.GET.get('mois')
    annee = request.GET.get('annee')
    
    if mois and annee:
        mois = int(mois)
        annee = int(annee)
        date_debut_objects = Datee.objects.filter(date__year=annee, date__month=mois)
    else:
        date_debut_objects = Datee.objects.all()

    formations = Formation.objects.all()
    resultats = set()
    somme_interne = 0
    somme_externe = 0
    total_effectifs_interne = 0
    total_effectifs_externe = 0

    # Initialisation des compteurs pour les catégories
    categorie_metier = 0
    categorie_ordre_legal = 0
    categorie_qualite = 0
    categorie_transverse = 0

    # Initialisation des compteurs pour les CSP
    csp_cadre = 0
    csp_maitrise = 0
    csp_execution = 0

    for formation in formations:
        date_ranges = Orienter.objects.filter(formation=formation, date_debut__in=date_debut_objects).values('date_debut', 'date_fin', 'sous_groupe').distinct()

        for date_range in date_ranges:
            date_debut_id = date_range['date_debut']
            date_fin_id = date_range['date_fin']
            
            date_debut_obj = Datee.objects.get(id_date=date_debut_id)
            date_fin_obj = Datee.objects.get(id_date=date_fin_id)

            nombre_interne = Orienter.objects.filter(
                formation=formation,
                type_formation='interne',
                date_debut=date_debut_obj,
                date_fin=date_fin_obj,
            ).count()

            nombre_externe = Orienter.objects.filter(
                formation=formation,
                type_formation='externe',
                date_debut=date_debut_obj,
                date_fin=date_fin_obj,
            ).count()

            effectifs_interne = ParticipantFormation.objects.filter(
                orientation__formation=formation,
                orientation__type_formation='interne',
                orientation__date_debut=date_debut_obj,
                orientation__date_fin=date_fin_obj,
                presence=True
            ).count()

            effectifs_externe = ParticipantFormation.objects.filter(
                orientation__formation=formation,
                orientation__type_formation='externe',
                orientation__date_debut=date_debut_obj,
                orientation__date_fin=date_fin_obj,
                presence=True
            ).count()

            total_effectifs_interne += effectifs_interne
            total_effectifs_externe += effectifs_externe

            if (formation.intitule, date_debut_obj.date, date_fin_obj.date) not in resultats:
                resultats.add((formation.intitule, date_debut_obj.date, date_fin_obj.date, nombre_interne, nombre_externe, effectifs_interne, effectifs_externe))

            # Compter les orientations par catégorie
            categorie = Orienter.objects.filter(formation=formation, date_debut=date_debut_obj, date_fin=date_fin_obj).values('categorie_formation').distinct()
            for cat in categorie:
                if cat['categorie_formation'] == 'métier':
                    categorie_metier += 1
                elif cat['categorie_formation'] == 'ordre_légal':
                    categorie_ordre_legal += 1
                elif cat['categorie_formation'] == 'qualité':
                    categorie_qualite += 1
                elif cat['categorie_formation'] == 'transverse':
                    categorie_transverse += 1

            # Compter les orientations par CSP basé sur les Effectifs
            effectifs = Effectif.objects.filter(
                participantformation__orientation__formation=formation,
                participantformation__orientation__date_debut=date_debut_obj,
                participantformation__orientation__date_fin=date_fin_obj,
                participantformation__presence=True
            ).values('csp').distinct()
            for eff in effectifs:
                if eff['csp'] == 'cadre':
                    csp_cadre += 1
                elif eff['csp'] == 'maitrise':
                    csp_maitrise += 1
                elif eff['csp'] == 'execution':
                    csp_execution += 1

    for r in resultats:
        somme_interne += r[3]
        somme_externe += r[4]

    somme_totale = somme_interne + somme_externe

    def somme_mois_precedents(annee, mois):
        somme_precedente = 0
        total_effectifs_precedent = 0
        for m in range(1, mois):  # Only include months before the current month
            date_debut_objects_prev = Datee.objects.filter(date__year=annee, date__month=m)
            somme_interne_prev = 0
            somme_externe_prev = 0
            effectifs_interne_prev = 0
            effectifs_externe_prev = 0

            for formation in formations:
                date_ranges_prev = Orienter.objects.filter(formation=formation, date_debut__in=date_debut_objects_prev).values('date_debut', 'date_fin', 'sous_groupe').distinct()

                for date_range_prev in date_ranges_prev:
                    date_debut_id_prev = date_range_prev['date_debut']
                    date_fin_id_prev = date_range_prev['date_fin']

                    date_debut_obj_prev = Datee.objects.get(id_date=date_debut_id_prev)
                    date_fin_obj_prev = Datee.objects.get(id_date=date_fin_id_prev)

                    nombre_interne_prev = Orienter.objects.filter(
                        formation=formation,
                        type_formation='interne',
                        date_debut=date_debut_obj_prev,
                        date_fin=date_fin_obj_prev,
                    ).count()

                    nombre_externe_prev = Orienter.objects.filter(
                        formation=formation,
                        type_formation='externe',
                        date_debut=date_debut_obj_prev,
                        date_fin=date_fin_obj_prev,
                    ).count()

                    effectifs_interne_prev += ParticipantFormation.objects.filter(
                        orientation__formation=formation,
                        orientation__type_formation='interne',
                        orientation__date_debut=date_debut_obj_prev,
                        orientation__date_fin=date_fin_obj_prev,
                        presence=True
                    ).count()

                    effectifs_externe_prev += ParticipantFormation.objects.filter(
                        orientation__formation=formation,
                        orientation__type_formation='externe',
                        orientation__date_debut=date_debut_obj_prev,
                        orientation__date_fin=date_fin_obj_prev,
                        presence=True
                    ).count()

                    somme_interne_prev += nombre_interne_prev
                    somme_externe_prev += nombre_externe_prev

            somme_totale_prev = somme_interne_prev + somme_externe_prev
            somme_precedente += somme_totale_prev
            total_effectifs_precedent += effectifs_interne_prev + effectifs_externe_prev

        return somme_precedente, total_effectifs_precedent

    if mois and annee:
        somme_precedente, total_effectifs_precedent = somme_mois_precedents(annee, mois)
    else:
        somme_precedente = 0
        total_effectifs_precedent = 0

    resultats_list = [{
        'formation': r[0],
        'date_debut': r[1],
        'date_fin': r[2],
        'nombre_interne': r[3],
        'nombre_externe': r[4],
        'effectifs_interne': r[5],
        'effectifs_externe': r[6]
    } for r in resultats]

    response_data = {
        'resultats': resultats_list,
        'somme_interne': somme_interne,
        'somme_externe': somme_externe,
        'somme_totale': somme_totale,
        'somme_precedente': somme_precedente + somme_totale,  # Add the current month's sum to the previous months' sum
        'total_effectifs_interne': total_effectifs_interne,
        'total_effectifs_externe': total_effectifs_externe,
        'total_effectifs_precedent': total_effectifs_precedent + total_effectifs_interne + total_effectifs_externe,  # Add the current month's effectifs to the previous months' effectifs
        'categorie_metier': categorie_metier,
        'categorie_ordre_legal': categorie_ordre_legal,
        'categorie_qualite': categorie_qualite,
        'categorie_transverse': categorie_transverse,
        'csp_cadre': csp_cadre,
        'csp_maitrise': csp_maitrise,
        'csp_execution': csp_execution
    }

    return JsonResponse(response_data, safe=False)





import json 

@csrf_exempt
def submit_froid(request):
    if request.method == 'POST':
        try:
            # Charger les données JSON envoyées depuis Flutter
            data = json.loads(request.body.decode('utf-8'))
            
            print(f"Received data: {data}")

            orienter_id = data.get('orienter')
            participant_oid = data.get('participant')  # ID du participant
            evaluateur_data = data.get('evaluateur', {})
            date_evaluation = data.get('date')
            recours = data.get('recours')
            besoin = data.get('besoin')
            precision = data.get('precision')
            objectif = data.get('objectif')
            rate_besoin = data.get('rate_besoin')
            rate_objectif = data.get('rate_objectif')
            rate_connaissance = data.get('rate_connaissance')
            rate_reduction_risque = data.get('rate_reduction_risque')
            rate_maitrise_metier = data.get('rate_maitrise_metier')
            taux_satisfaction = data.get('taux_satisfaction')

            # Récupérer ou créer l'évaluateur
            if evaluateur_data:
                evaluateur_matricule = evaluateur_data.get('matricule')
                evaluateur_nom = evaluateur_data.get('nom')
                evaluateur_prenom = evaluateur_data.get('prenom')
                
                responsable_hiearchique = get_object_or_404(Responsable_hiearchique, matricule=evaluateur_matricule)
                evaluateur, created = Evaluateur.objects.get_or_create(
                    matricule=evaluateur_matricule,
                    defaults={
                        'nom': evaluateur_nom,
                        'prenom': evaluateur_prenom,
                        'date_de_naissance': responsable_hiearchique.date_de_naissance,
                    }
                )
            else:
                return JsonResponse({'error': 'Données de l\'évaluateur manquantes'}, status=400)

            # Récupérer l'orientation
            orienter = get_object_or_404(Orienter, id=orienter_id)

            # Récupérer le participant (Effectif)
            if participant_oid:
                participant = get_object_or_404(Effectif, id=participant_oid)  # Assurez-vous que `id` est bien la clé primaire
            else:
                return JsonResponse({'error': 'ID du participant manquant'}, status=400)

            # Enregistrer les données dans Evaluerfroid
            evaluation = Evaluerfroid(
                orienter=orienter,
                participant=participant,
                evaluateur=evaluateur,
                date=date_evaluation,
                recours=recours,
                besoin=besoin,
                precision=precision,
                objectif=objectif,
                rate_besoin=rate_besoin,
                rate_objectif=rate_objectif,
                rate_connaissance=rate_connaissance if rate_connaissance is not None else 0,  # Gérer null
                rate_reduction_risque=rate_reduction_risque,
                rate_maitrise_metier=rate_maitrise_metier,
                taux_satisfaction=taux_satisfaction,
            )
            evaluation.save()  # Sauvegarder l'objet dans la base de données

            return JsonResponse({'message': 'Évaluation soumise avec succès'}, status=201)
        
        except Exception as e:
            print(f"Error details: {e}")
            return JsonResponse({'error': 'Erreur lors de la soumission de l\'évaluation', 'details': str(e)}, status=500)
    
    return JsonResponse({'error': 'Méthode de requête invalide'}, status=405)



from django.urls import reverse

@csrf_exempt
def send_form_email(request):
    today = timezone.now().date()

    # Trouver toutes les formations dont la date de fin est aujourd'hui
    datee_instances = Datee.objects.filter(date=today)
    if not datee_instances.exists():
        return JsonResponse({'message': 'No formations ending today'}, status=200)

    for datee_instance in datee_instances:
        orientations_today = Orienter.objects.filter(date_fin=datee_instance)
        if not orientations_today.exists():
            continue  # Passer à la date suivante si aucune formation ne se termine aujourd'hui pour cette date

        for orientation in orientations_today:
            participants = ParticipantFormation.objects.filter(orientation=orientation, presence=True)
            
            for participant_formation in participants:
                participant = participant_formation.participant
                email = participant.email  # Assurez-vous que le modèle Effectif a un champ email
                if not email:
                    continue  # Si l'email est manquant, passez au participant suivant

               # Générer le lien vers le formulaire
                form_link = request.build_absolute_uri(
                    reverse('submit_forms') + f'?id={orientation.id}'
                )

                # Créer le contenu HTML de l'email avec le lien
                html_content = f"""
                <html>
                <body>
                    <p>Bonjour {participant.prenom} {participant.nom},</p>
                    <p>Nous vous invitons à évaluer la formation "{orientation.formation.intitule}".</p>
                    <p>qui a déroulé du  {orientation.date_debut} au {orientation.date_fin}</p>
                    <p>Veuillez cliquer sur le lien suivant pour accéder au formulaire d'évaluation :</p>
                    <p><a href="{form_link}">Évaluer la formation</a></p>
                    <p>Cordialement,<br>L'équipe de formation</p>
                </body>
                </html>
                """

                # Créer l'email
                email_message = EmailMessage(
                    'Évaluation de la formation',
                    html_content,
                    'aissoumanel009@gmail.com',  # Remplacez par votre email d'envoi
                    [email],
                )
                email_message.content_subtype = 'html'  # Indiquer que le contenu est du HTML

                try:
                    email_message.send()
                except Exception as e:
                    # Ajouter des logs pour l'erreur d'envoi d'email
                    print(f"Failed to send email to {email}: {e}")
                    return JsonResponse({'error': str(e)}, status=500)

    return JsonResponse({'message': 'Emails sent successfully'}, status=200)


from django.db.models import Sum


def filter_budgets(request):
    mois = request.GET.get('mois')
    année = request.GET.get('annee')

    # Convertir les paramètres en entiers si présents
    mois = int(mois) if mois else None
    année = int(année) if année else None

    queryset = Dashboardbudjets.objects.all()

    if mois is not None:
        queryset = queryset.filter(mois=mois)
    if année is not None:
        queryset = queryset.filter(annee=année)

    # Calculer la somme des valeurs 'réalisé' pour les mois passés et le mois en cours
    if mois is not None and année is not None:
        cumul = Dashboardbudjets.objects.filter(
            annee=année,
            mois__lte=mois
        ).aggregate(total_realise=Sum('realise'))['total_realise'] or 0
    else:
        cumul = 0

    # Construire la réponse JSON manuellement
    data = list(queryset.values('realise', 'Prevu', 'Plan' , 'mois' , 'annee'))
    
    response_data = {
        'resultats': data,
        'cumul': cumul
    }
    
    return JsonResponse(response_data)




from django.views.decorators.http import require_http_methods
@csrf_exempt
@require_http_methods(["PUT"])
def DashboardUpdateView(request):
    data = json.loads(request.body)
    mois = data.get('mois')
    annee = data.get('annee')
    
    try:
        mois = int(mois)
        annee = int(annee)
        dashboards = Dashboard.objects.filter(mois=mois, annee=annee)
    except ValueError:
        return JsonResponse({'error': 'Invalid month or year'}, status=400)
    
    if not dashboards.exists():
        return JsonResponse({'error': 'Dashboard not found'}, status=404)

    # Mettre à jour les champs du premier objet trouvé
    dashboard = dashboards.first()
    dashboard.prevu_action_formation = data.get('prevu_action_formation', dashboard.prevu_action_formation)
    dashboard.prevu_effectifs = data.get('prevu_effectifs', dashboard.prevu_effectifs)
    dashboard.Plan_fromation = data.get('Plan_fromation', dashboard.Plan_fromation)
    dashboard.Plan_effectifs = data.get('Plan_effectifs', dashboard.Plan_effectifs)
    dashboard.save()

    # Ajoutez un message de débogage pour vérifier les données mises à jour
    updated_data = {
        'prevu_action_formation': dashboard.prevu_action_formation,
        'prevu_effectifs': dashboard.prevu_effectifs,
        'Plan_fromation': dashboard.Plan_fromation,
        'Plan_effectifs': dashboard.Plan_effectifs,
    }
    print(f'Dashboard updated with: {updated_data}')

    return JsonResponse({'success': 'Dashboard updated successfully'})



@csrf_exempt
@require_http_methods(["PUT"])
def DashboardBudjetUpdateView(request):
    data = json.loads(request.body)
    mois = data.get('mois')
    annee = data.get('annee')

    try:
        mois = int(mois)
        annee = int(annee)
        dashboards = Dashboardbudjets.objects.filter(mois=mois, annee=annee)
    except ValueError:
        return JsonResponse({'error': 'Invalid month or year'}, status=400)

    if not dashboards.exists():
        return JsonResponse({'error': 'Dashboard not found'}, status=404)

    dashboard = dashboards.first()
    dashboard.realise = data.get('realise', dashboard.realise)
    dashboard.Prevu = data.get('Prevu', dashboard.Prevu)
    dashboard.Plan = data.get('Plan', dashboard.Plan)
    
    if 'mois' in data:
        dashboard.mois = mois
    if 'annee' in data:
        dashboard.annee = annee
    
    dashboard.save()

    updated_data = {
        'realise': dashboard.realise,
        'Prevu': dashboard.Prevu,
        'Plan': dashboard.Plan,
        'mois': dashboard.mois,
        'annee': dashboard.annee,
    }
    return JsonResponse({'success': 'Dashboard updated successfully'})


def filter_dashboard(request):
    mois = request.GET.get('mois')
    annee = request.GET.get('annee')

    # Convertir les paramètres en entiers si présents
    mois = int(mois) if mois else None
    annee = int(annee) if annee else None

    queryset = Dashboard.objects.all()

    if mois is not None:
        queryset = queryset.filter(mois=mois)
    if annee is not None:
        queryset = queryset.filter(annee=annee)
    
    # Construire la réponse JSON manuellement
    data = list(queryset.values(
        'prevu_action_formation', 'prevu_effectifs', 'Plan_fromation',
        'Plan_effectifs', 'mois', 'annee'
    ))
    
    return JsonResponse({'resultats': data})



from datetime import datetime, timedelta
from django.db.models import Q
from django.http import JsonResponse





def tableau_data(request):
    # Récupération des paramètres de filtre depuis les requêtes GET
    mois_debut = request.GET.get('mois_debut', None)  # Format: 'YYYY-MM'
    intitule_formation = request.GET.get('intitule_formation', None)

    data = {
        'evaluateurs': [],  # Liste des évaluateurs
        'evaluations': {},  # Évaluations par évaluateur
        'orienter_details': {}  # Détails de formation et orienter
    }

    # Construction de la requête de filtrage
    filters = Q()

    if mois_debut:
        try:
            # Extraire le mois et l'année de mois_debut
            mois_debut_date = datetime.strptime(mois_debut, '%Y-%m')
            start_date = mois_debut_date.replace(day=1)
            next_month = mois_debut_date.replace(day=28) + timedelta(days=4)  # Assure de passer au mois suivant
            end_date = next_month.replace(day=1) - timedelta(days=1)
            filters &= Q(orienter__date_debut__date__range=(start_date, end_date))
        except ValueError:
            pass  # Gérer l'erreur de format de date ici si nécessaire

    if intitule_formation:
        filters &= Q(orienter__formation__intitule__icontains=intitule_formation)

    print(f"Filters: {filters}")

    # Récupération des évaluations avec les informations de formation et orienter
    evaluations = Evaluerchaud.objects.select_related(
        'orienter__formation__formateur',
    ).filter(filters).all()

    for evaluation in evaluations:
        evaluateur_id = evaluation.evaluateur.id
        evaluation_id = evaluation.id  # Identifiant unique de l'évaluation

        # Ajout de l'évaluateur à la liste s'il n'y est pas déjà
        if evaluateur_id not in data['evaluateurs']:
            data['evaluateurs'].append(evaluateur_id)

        # Récupération des informations de formation et orienter
        orienter = evaluation.orienter
        formation = orienter.formation
        formateur = formation.formateur
        formation_details = {
            'id_formation': formation.id_formation,
            'intitule': formation.intitule,
            'formateur_nom': formateur.nom,
            'formateur_prenom': formateur.prenom,
        }

        # Calcul du nombre de participants présents et du taux de présence
        total_participants = ParticipantFormation.objects.filter(orientation=orienter).count()
        participants_presents = ParticipantFormation.objects.filter(orientation=orienter, presence=True).count()
        taux_presence = (participants_presents / total_participants) * 100 if total_participants > 0 else 0

        orienter_details = {
            'sous_groupe': str(orienter.sous_groupe),
            'date_debut': str(orienter.date_debut.date),  # Utilisation du champ `date` du modèle `Datee`
            'date_fin': str(orienter.date_fin.date),      # Utilisation du champ `date` du modèle `Datee`
            'organisme_formation': str(orienter.organisme_formation),
            'lieu_formation': str(orienter.lieu_formation),
            'formation': (formation_details),
            'participants_presents': total_participants ,
            'taux_presence': taux_presence,
        }

        # Ajouter les détails de formation et orienter au dictionnaire 'orienter_details'
        if evaluateur_id not in data['orienter_details']:
            data['orienter_details'][evaluateur_id] = {}

        # Ajouter les détails pour chaque évaluation spécifique
        data['orienter_details'][evaluateur_id][evaluation_id] = orienter_details

        # Ajouter l'évaluation à la liste des évaluations de cet évaluateur
        if evaluateur_id not in data['evaluations']:
            data['evaluations'][evaluateur_id] = []

        evaluation_data = {
            'objectifs': str(evaluation.get_evaluation_value('objectifs')),
            'contenu': str(evaluation.get_evaluation_value('contenu')),
            'equilibre': str(evaluation.get_evaluation_value('equilibre')),
            'documentation': str(evaluation.get_evaluation_value('documentation')),
            'methodes': str(evaluation.get_evaluation_value('methodes')),
            'communication': str(evaluation.get_evaluation_value('communication')),
            'adaptation': str(evaluation.get_evaluation_value('adaptation')),
            'participation': str(evaluation.get_evaluation_value('participation')),
            'interet': str(evaluation.get_evaluation_value('interet')),
            'duree': str(evaluation.get_evaluation_value('duree')),
            'local': str(evaluation.get_evaluation_value('local')),
            'moyens': str(evaluation.get_evaluation_value('moyens')),
            'comprehension': str(evaluation.get_evaluation_value('comprehension')),
            'applicables': str(evaluation.get_evaluation_value('applicables')),
            'satisfaction': str(evaluation.get_evaluation_value('satisfaction')),
            'recommendation': str(evaluation.get_evaluation_value('recommendation')),
        }

        data['evaluations'][evaluateur_id].append({
            'evaluation_id': evaluation_id,
            'data': evaluation_data
        })

    return JsonResponse(data)

def get_participant_id(request):
    nom = request.GET.get('nom')
    prenom = request.GET.get('prenom')
    matricule = request.GET.get('matricule')

    try:
        participant = Effectif.objects.get(nom=nom, prenom=prenom, matricule=matricule)
        return JsonResponse({'participant_id': participant.id})
    except Effectif.DoesNotExist:
        return JsonResponse({'error': 'Participant not found'}, status=404)

from urllib.parse import urlencode
from uuid import uuid4
from django.utils.http import urlencode


def envoyer_evaluations(request):
    today = timezone.now().date()
    
    # Récupérer les orientations dont la date de fin est passée depuis plus de 6 mois
    orientations = Orienter.objects.all()
    
    if not orientations.exists():
        # Aucun enregistrement trouvé pour les évaluations
        return JsonResponse({'status': 'error', 'message': 'Il n\'y a pas de formations disponibles.'})
    
    emails_sent = 0
    
    for orientation in orientations:
        # Calculer la date limite pour l'évaluation (6 mois après la date de fin)
        evaluation_deadline = orientation.date_fin.date + timedelta(days=6*30)
        print(evaluation_deadline)
        
        if today >= evaluation_deadline:
            # Récupérer le responsable hiérarchique associé à cette orientation
            responsable = orientation.responsable_hiearchique
                        
            # Générer un lien pour accéder à la plateforme d'évaluation
            params = {
                'id': str(orientation.id),  # Assurez-vous que l'id est une chaîne UUID valide
            }
            
            
            query_string = urlencode(params)
            evaluation_link = f"http://localhost:8000/#/evaluationfroid?{query_string}"
            
            # Envoyer l'email avec le lien
            send_mail(
                'Évaluation de la formation',
                f'Bonjour {responsable.prenom} {responsable.nom},\n\nVeuillez évaluer la formation en suivant ce lien : {evaluation_link}',
                'aissoumanel009@gmail.com',
                [responsable.email],
                fail_silently=False,
            )
            
            emails_sent += 1
    
    if emails_sent == 0:
        return JsonResponse({'status': 'info', 'message': 'Aucun email envoyé : aucune formation à évaluer.'})
    
    return JsonResponse({'status': 'success', 'message': f'{emails_sent} emails envoyés pour les évaluations.'})


def filter_participant_formation(request):
    orientation_id = request.GET.get('orientation_id')
    participant_id = request.GET.get('participant_id')

    # Construire le queryset de base
    queryset = ParticipantFormation.objects.all()

    if orientation_id:
        queryset = queryset.filter(orientation_id=orientation_id)
    if participant_id:
        queryset = queryset.filter(participant_id=participant_id)

    # Préparer la réponse JSON
    data = list(queryset.values(
         'presence', 'etat'
    ))

    return JsonResponse({'resultats': data})


@csrf_exempt
@require_http_methods(["PUT"])
def ParticipantFormationUpdateView(request):
    data = json.loads(request.body)
    
    participant_id = data.get('participant_id')
    orientation_id = data.get('orientation_id')

    try:
        participant_formation = ParticipantFormation.objects.get(
            participant_id=participant_id, orientation_id=orientation_id
        )
    except ParticipantFormation.DoesNotExist:
        return JsonResponse({'error': 'ParticipantFormation not found'}, status=404)

    # Mettre à jour les champs pertinents
    participant_formation.presence = data.get('presence', participant_formation.presence)
    participant_formation.etat = data.get('etat', participant_formation.etat)
    
    participant_formation.save()

    updated_data = {
        'participant': str(participant_formation.participant),
        'orientation': str(participant_formation.orientation),
        'presence': participant_formation.presence,
        'etat': participant_formation.etat,
    }

    return JsonResponse({'success': 'ParticipantFormation updated successfully', 'updated_data': updated_data})

def get_orientation_details(request, id):
    try:
        orientation = Orienter.objects.get(id=id)
        participants = orientation.sous_groupe.participants.all()
        participant_details = [
            {
                'nom': p.nom,
                'prenom': p.prenom,
                'structure': p.structure,
                'service': p.service,
                'matricule': p.matricule
            }
            for p in participants
        ]

        # Récupération des détails du responsable hiérarchique
        responsable = orientation.responsable_hiearchique
        responsable_details = {
            'nom': responsable.nom,
            'prenom': responsable.prenom,
            'matricule': responsable.matricule
        }

        data = {
            'intituleFormation': orientation.formation.intitule,
            'dateFormation': orientation.date_debut.date,
            'categorieFormation': orientation.categorie_formation,
            'participants': participant_details,
            'responsable': responsable_details  # Ajout des détails du responsable hiérarchique
        }
        return JsonResponse(data)
    except Orienter.DoesNotExist:
        return JsonResponse({'error': 'Orientation non trouvée'}, status=404)
    

@csrf_exempt
def delete_dashboardBudjets(request, mois, annee):
    if request.method == 'DELETE':
        # Trouver l'enregistrement du modèle Dashboard en fonction du mois et de l'année
        dashboard = get_object_or_404(Dashboardbudjets, mois=mois, annee=annee)
        dashboard.delete()
        return JsonResponse({'message': 'Dashboardbudjet supprimé avec succès'}, status=200)
    else:
        return HttpResponseNotFound('Méthode non autorisée')

@csrf_exempt
def delete_dashboard(request, mois, annee):
    if request.method == 'DELETE':
        # Trouver l'enregistrement du modèle Dashboard en fonction du mois et de l'année
        dashboard = get_object_or_404(Dashboard, mois=mois, annee=annee)
        dashboard.delete()
        return JsonResponse({'message': 'Dashboard supprimé avec succès'}, status=200)
    else:
        return HttpResponseNotFound('Méthode non autorisée')

@csrf_exempt
def get_all_data(request):
    # Fetch data from models
    orienters = Orienter.objects.all().select_related(
        'formation', 'responsable_hiearchique', 'sous_groupe', 'date_debut', 'date_fin'
    ).values(
        'id', 'sous_groupe__nom', 'formation__intitule', 'date_debut__date', 'date_fin__date',
        'organisme_formation', 'code_tiers',  
        'lieu_formation', 'type_formation', 'categorie_formation',  
        'responsable_hiearchique__nom', 'responsable_hiearchique__prenom', 'cout_total', 'NumBc', 'Facture_Pédagogique',
        'NuméroFacture_Pédagogique', 'Organisme_logistque', 'Facture_Hotel', 'cout_logistique', 'Enjeu'
    )

    participants = ParticipantFormation.objects.select_related('participant', 'orientation').all()
    evaluations_chaud = Evaluerchaud.objects.select_related('orienter', 'evaluateur').all()
    evaluations_froid = Evaluerfroid.objects.select_related('orienter', 'participant').all()

    # Prepare data structure for orientations
    orientation_data = {}
    for orienter in orienters:
        orientation_id = str(orienter['id'])  # Convert UUID to string
        if orientation_id not in orientation_data:
            orientation_data[orientation_id] = {
                'id': orientation_id,
                'sous_groupe': orienter['sous_groupe__nom'],
                'formation': orienter['formation__intitule'],
                'date_debut': orienter['date_debut__date'],  # Here we fetch the actual date
                'date_fin': orienter['date_fin__date'],  # Here we fetch the actual date
                'organisme_formation': orienter['organisme_formation'],
                'code_tiers': orienter['code_tiers'],  
                'lieu_formation': orienter['lieu_formation'],
                'type_formation': orienter['type_formation'],
                'categorie_formation': orienter['categorie_formation'],  
                'responsable_hiearchique': f"{orienter['responsable_hiearchique__nom']} {orienter['responsable_hiearchique__prenom']}",
                'cout_total': orienter['cout_total'],
                'NumBc': orienter['NumBc'],
                'Facture_Pédagogique': orienter['Facture_Pédagogique'],
                'NuméroFacture_Pédagogique': orienter['NuméroFacture_Pédagogique'],
                'Organisme_logistque': orienter['Organisme_logistque'],
                'Facture_Hotel': orienter['Facture_Hotel'],
                'cout_logistique': orienter['cout_logistique'],
                'Enjeu': orienter['Enjeu'],
                'participants': {}
            }


    participant_map = {}
    for participant in participants:
        orientation_id = str(participant.orientation_id)
        if orientation_id not in orientation_data:
            continue
        
        effectif = participant.participant
        if effectif.id not in participant_map:
            participant_map[effectif.id] = {
                'id': effectif.id,
                'nom': effectif.nom,
                'prenom': effectif.prenom,
                'matricule': effectif.matricule,
                'date_de_naissance': effectif.date_de_naissance,
                'structure': effectif.structure,
                'fonction': effectif.fonction ,
                'pole': effectif.pole,
                'service': effectif.service,
                'email': effectif.email,
                'presence': participant.presence,
                'csp': effectif.csp,
                'etat': participant.etat,
                'evaluations_chaud': [],  # Initialize evaluations_chaud list
                'evaluations_froid': []  # Initialize evaluations_froid list
            }
        
        orientation_data[orientation_id]['participants'][effectif.id] = participant_map[effectif.id]

    # Attach hot evaluations data to participants within each orientation
    for evaluation in evaluations_chaud:
        orienter_id = str(evaluation.orienter_id)  # Convert UUID to string
        evaluateur_id = evaluation.evaluateur_id
        if orienter_id in orientation_data:
            for participant_id, participant in orientation_data[orienter_id]['participants'].items():
                if participant_id == evaluateur_id:  # Check if evaluator matches participant
                    taux_evaluation = evaluation.taux_evaluation
                    
                    participant['evaluations_chaud'].append({
                        'date_evaluation': evaluation.date_evaluation,
                        'objectifs': evaluation.objectifs,
                        'contenu': evaluation.contenu,
                        'equilibre': evaluation.equilibre,
                        'documentation': evaluation.documentation,
                        'methodes': evaluation.methodes,
                        'communication': evaluation.communication,
                        'adaptation': evaluation.adaptation,
                        'participation': evaluation.participation,
                        'interet': evaluation.interet,
                        'duree': evaluation.duree,
                        'local': evaluation.local,
                        'moyens': evaluation.moyens,
                        'comprehension': evaluation.comprehension,
                        'applicables': evaluation.applicables,
                        'satisfaction': evaluation.satisfaction,
                        'recommendation': evaluation.recommendation,
                        'evaluateur': {
                            'id': evaluation.evaluateur_id,
                            'nom': evaluation.evaluateur.nom,
                            'prenom': evaluation.evaluateur.prenom
                        },
                        'taux_evaluation': taux_evaluation  
                    })

    # Attach cold evaluations data to participants within each orientation
    for evaluation in evaluations_froid:
        orienter_id = str(evaluation.orienter_id)  # Convert UUID to string
        participant_id = evaluation.participant_id
        if orienter_id in orientation_data and participant_id in orientation_data[orienter_id]['participants']:
            participant = orientation_data[orienter_id]['participants'][participant_id]

            participant['evaluations_froid'].append({
                'date': evaluation.date,
                'recours': evaluation.recours,
                'besoin': evaluation.besoin,
                'precision': evaluation.precision,
                'objectif': evaluation.objectif,
                'rate_besoin': evaluation.rate_besoin,
                'rate_objectif': evaluation.rate_objectif,
                'rate_connaissance': evaluation.rate_connaissance,
                'rate_reduction_risque': evaluation.rate_reduction_risque,
                'rate_maitrise_metier': evaluation.rate_maitrise_metier,
                'taux_satisfaction': evaluation.taux_satisfaction,
            })

    # Construct JSON response
    response_data = {
        'orienters': list(orientation_data.values()),
    }

    return JsonResponse(response_data)
from django.http import JsonResponse, HttpResponseNotAllowed
from uuid import UUID
@csrf_exempt
def delete_ParticipantFormation(request, participant_id, orientation_id):
    if request.method == 'DELETE':
        # Vérifiez si orientation_id est un UUID valide
        try:
            uuid_obj = UUID(orientation_id, version=4)
        except ValueError:
            return JsonResponse({'message': 'UUID invalide'}, status=400)

        # Trouver l'enregistrement du modèle ParticipantFormation
        participant_formation = get_object_or_404(ParticipantFormation, participant_id=participant_id, orientation_id=uuid_obj)
        participant_formation.delete()
        return JsonResponse({'message': 'ParticipantFormation supprimé avec succès'}, status=204)
    else:
        return HttpResponseNotAllowed(['DELETE'], 'Méthode non autorisée')
    
class ParticipantsByOrientationView(generics.ListAPIView):
    serializer_class = ParticipantFormationSerializer

    def get_queryset(self):
        orientation_id = self.kwargs.get('orientation_id')
        date_debut = self.request.query_params.get('date_debut')
        date_fin = self.request.query_params.get('date_fin')

        # Convertir les dates de début et de fin depuis les paramètres de requête
        try:
            date_debut = datetime.strptime(date_debut, '%Y-%m-%d') if date_debut else None
            date_fin = datetime.strptime(date_fin, '%Y-%m-%d') if date_fin else None
        except ValueError:
            date_debut = None
            date_fin = None

        # Filtrage par ID de l'orientation et, éventuellement, par dates de début et de fin
        queryset = ParticipantFormation.objects.filter(
            orientation_id=orientation_id
        )

        if date_debut:
            queryset = queryset.filter(
                orientation__date_debut__date__gte=date_debut
            )
        if date_fin:
            queryset = queryset.filter(
                orientation__date_fin__date__lte=date_fin
            )

        return queryset.select_related('participant', 'orientation')

def participants_sous_groupe_json(request, nom_sous_groupe):
    # Récupérer le sous-groupe en fonction du nom
    sous_groupe = get_object_or_404(SousGroupe, nom=nom_sous_groupe)
    
    # Récupérer les participants du sous-groupe
    participants = sous_groupe.participants.all()
    
    # Construire une liste de dictionnaires représentant chaque participant
    participants_data = [
        {
            'nom': participant.nom,
            'prenom': participant.prenom,
            'date_de_naissance': participant.date_de_naissance,
            'matricule': participant.matricule,
            'structure': participant.structure,
            'service': participant.service,
        }
        for participant in participants
    ]
    
    # Retourner les données sous forme de JSON
    return JsonResponse({'sous_groupe': sous_groupe.nom, 'participants': participants_data})

class FilterByCriteriaView(generics.ListAPIView):
    serializer_class = OrienterSerializer

    def get_queryset(self):
        structure = self.request.query_params.get('structure')
        pole = self.request.query_params.get('pole')
        month = self.request.query_params.get('month')

        queryset = Orienter.objects.all()

        if structure or pole:
            # Filtrer selon les relations avec Effectif via SousGroupe
            queryset = queryset.filter(
                sous_groupe__participants__structure=structure,
                sous_groupe__participants__pole=pole
            ).distinct()

        if month:
            month_number = self.get_month_number(month)
            if month_number:
                queryset = queryset.filter(date_debut__date__month=month_number)

        return queryset

    def get_month_number(self, month):
        """Convert month name to month number."""
        month_mapping = {
            'janvier': 1,
            'février': 2,
            'mars': 3,
            'avril': 4,
            'mai': 5,
            'juin': 6,
            'juillet': 7,
            'août': 8,
            'septembre': 9,
            'octobre': 10,
            'novembre': 11,
            'décembre': 12
        }
        return month_mapping.get(month)







class RegisterView(generics.GenericAPIView):
    serializer_class = RegisterSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        return Response({
            "user": RegisterSerializer(user, context=self.get_serializer_context()).data
        }, status=status.HTTP_201_CREATED)


@csrf_exempt
def get_formation_by_intitule(request, intitule):
    if request.method == 'GET':
        try:
            formation = Formation.objects.get(intitule=intitule)
            data = {
                'id_formation': formation.id_formation,
                'intitule': formation.intitule,
                'formateur': formation.formateur.id,  # Assumes formateur has an 'id' attribute
            }
            return JsonResponse(data)
        except Formation.DoesNotExist:
            return HttpResponseNotFound('Formation non trouvée')
    else:
        return HttpResponseNotAllowed(['GET'], 'Méthode non autorisée')
    
from django.core.exceptions import ValidationError

@csrf_exempt
@require_http_methods(['PUT'])
def update_formation(request, intitule):
    try:
        formation = Formation.objects.get(intitule=intitule)
    except Formation.DoesNotExist:
        return HttpResponseNotFound('Formation non trouvée')

    try:
        data = json.loads(request.body)
        formation.intitule = data.get('intitule', formation.intitule)
        formateur_id = data.get('formateur')
        if formateur_id:
            formation.formateur_id = formateur_id
        formation.save()
        return JsonResponse({
            'id_formation': formation.id_formation,
            'intitule': formation.intitule,
            'formateur': formation.formateur.id,
        })
    except (ValidationError, KeyError, json.JSONDecodeError) as e:
        return JsonResponse({'message': f'Erreur lors de la mise à jour: {str(e)}'}, status=400)
    


@csrf_exempt
def delete_formation(request, intitule):
    if request.method == 'DELETE':
        try:
            formation = Formation.objects.get(intitule=intitule)
            formation.delete()
            return JsonResponse({'message': 'Formation supprimée avec succès'}, status=204)
        except Formation.DoesNotExist:
            return HttpResponseNotFound('Formation non trouvée')
    else:
        return HttpResponseNotAllowed(['DELETE'], 'Méthode non autorisée')