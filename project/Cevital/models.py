from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator
from datetime import date
class Effectif(models.Model):
    CSP_CHOICES = [
        ('cadre', 'Cadre'),
        ('maitrise', 'Maitrise'),
        ('execution', 'Exécution'),
    ]
     
    nom = models.CharField(max_length=50)
    prenom = models.CharField(max_length=50)
    date_de_naissance = models.DateField(blank=False, null=False, default=date.today)
    matricule = models.CharField(max_length=50, unique=True, blank=False, null=False)
    structure = models.CharField(max_length=50, blank=False, null=False)
    service = models.CharField(max_length=50, blank=False, null=False)
    email = models.EmailField( default='pas_d_email@example.com')
    fonction = models.CharField(max_length=50)
    pole = models.CharField(max_length=50)
    csp = models.CharField(max_length=50, choices=CSP_CHOICES)

    def __str__(self):
        return f"{self.matricule}"

class Categorie(models.Model):
    nom = models.CharField(max_length=50)

    def __str__(self):
        return self.nom
    
class Formateur(models.Model):
    nom = models.CharField(max_length=50)
    prenom = models.CharField(max_length=50)
    date_de_naissance = models.DateField(blank=False, null=False)
    matricule = models.CharField(max_length=50, unique=True, blank=False, null=False)
    

    def __str__(self):
        return f"{self.matricule}"
    

class Responsable_hiearchique(models.Model):
    nom = models.CharField(max_length=50)
    prenom = models.CharField(max_length=50)
    date_de_naissance = models.DateField(blank=False, null=False)
    matricule = models.CharField(max_length=50, unique=True, blank=False, null=False)
    email = models.EmailField(unique=True, blank=False, null=False)
    

    def __str__(self):
        return f"{self.matricule}"
    
    
class Formation(models.Model):
    id_formation = models.AutoField(primary_key=True)
    intitule = models.CharField(max_length=255, null=False, blank=False)
    formateur = models.ForeignKey(Formateur , null=False, blank=False ,on_delete=models.CASCADE)

    def __str__(self):
        return f"{self.intitule}"
    


class Datee(models.Model):
    id_date = models.AutoField(primary_key=True)
    date = models.DateField(blank=False, null=False)

    def __str__(self):
        return str(self.date) 

class SousGroupe(models.Model):
    nom = models.CharField(max_length=50)
    participants = models.ManyToManyField(Effectif)

    def __str__(self):
        return f"Sous-groupe {self.nom}"
    


import uuid
class Orienter(models.Model):
    # Définir les choix pour le champ categorie
    CATEGORIE_CHOICES = [
        ('métier', 'Métier'),
        ('ordre_légal', 'Ordre légal'),
        ('qualité', 'Qualité'),
        ('transverse', 'Transverse'),
    ]
   
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    sous_groupe = models.ForeignKey(SousGroupe, on_delete=models.CASCADE)
    formation = models.ForeignKey(Formation, on_delete=models.CASCADE)
    date_debut = models.ForeignKey(Datee, related_name='orienter_date_debut', on_delete=models.CASCADE)
    date_fin = models.ForeignKey(Datee, related_name='orienter_date_fin', on_delete=models.CASCADE)
    organisme_formation = models.CharField(max_length=50)
    code_tiers = models.CharField(max_length=50)
    lieu_formation = models.CharField(max_length=50)
    type_formation = models.CharField(max_length=50, blank=False, null=False)
    categorie_formation = models.CharField(max_length=50, choices=CATEGORIE_CHOICES)
    responsable_hiearchique = models.ForeignKey(Responsable_hiearchique, on_delete=models.CASCADE)
    cout_total = models.CharField(max_length=50)
    NumBc = models.CharField(max_length=50)
    Facture_Pédagogique = models.CharField(max_length=50)
    NuméroFacture_Pédagogique = models.CharField(max_length=50)
    Organisme_logistque = models.CharField(max_length=50)
    Facture_Hotel = models.CharField(max_length=50)
    cout_logistique = models.CharField(max_length=50)
    Enjeu = models.CharField(max_length=50)
    

    class Meta:
        unique_together = ('formation', 'date_debut', 'date_fin', 'sous_groupe')

    def __str__(self):
        return f"{self.formation} - {self.date_debut.date} - {self.date_fin.date} - {self.type_formation} - {self.sous_groupe}"
    

    
class ParticipantFormation(models.Model):
    participant = models.ForeignKey(Effectif, on_delete=models.CASCADE)
    orientation = models.ForeignKey(Orienter, on_delete=models.CASCADE)  
    presence = models.BooleanField(default=False)
    etat=models.CharField(max_length=50)

    def __str__(self):
        return f"{self.participant} in {self.orientation}"
    


class Dashboardbudjets(models.Model):
    realise = models.CharField(max_length=50)
    Prevu = models.CharField(max_length=50)
    Plan = models.CharField(max_length=50)
    mois = models.IntegerField(choices=[
        (1, 'Janvier'), (2, 'Février'), (3, 'Mars'),
        (4, 'Avril'), (5, 'Mai'), (6, 'Juin'),
        (7, 'Juillet'), (8, 'Août'), (9, 'Septembre'),
        (10, 'Octobre'), (11, 'Novembre'), (12, 'Décembre')
    ])
    annee = models.IntegerField()

    def __str__(self):
        return f"{self.id} - {self.Plan} - {self.get_mois_display()} {self.annee}"

    class Meta:
        unique_together = ('realise', 'Prevu', 'mois', 'annee')


class Dashboard(models.Model):
    prevu_action_formation = models.CharField(max_length=50)
    prevu_effectifs = models.CharField(max_length=50)
    Plan_fromation= models.CharField(max_length=50)
    Plan_effectifs =models.IntegerField()
    mois = models.IntegerField(choices=[
        (1, 'Janvier'), (2, 'Février'), (3, 'Mars'),
        (4, 'Avril'), (5, 'Mai'), (6, 'Juin'),
        (7, 'Juillet'), (8, 'Août'), (9, 'Septembre'),
        (10, 'Octobre'), (11, 'Novembre'), (12, 'Décembre')
    ])
    annee = models.IntegerField()

    def __str__(self):
         return f"{self.id}  - {self.get_mois_display()} {self.annee}"
    


class Evaluateur(models.Model):
    nom = models.CharField(max_length=50)
    prenom = models.CharField(max_length=50)
    date_de_naissance = models.DateField(blank=False, null=False)
    matricule = models.CharField(max_length=50, unique=True, blank=False, null=False)

    def __str__(self):
        return f"{self.matricule}"
    

class Evaluerfroid(models.Model):
    evaluation_id = models.AutoField(primary_key=True)
    orienter = models.ForeignKey('Orienter', on_delete=models.CASCADE)
    participant = models.ForeignKey(Effectif, on_delete=models.CASCADE)
    evaluateur = models.ForeignKey(Evaluateur, on_delete=models.CASCADE)
    date = models.DateField()
    recours = models.TextField()
    besoin = models.TextField()
    precision = models.TextField()
    objectif = models.TextField()
    rate_besoin = models.IntegerField(validators=[MinValueValidator(1), MaxValueValidator(5)])
    rate_objectif = models.IntegerField(validators=[MinValueValidator(1), MaxValueValidator(5)])
    rate_connaissance = models.IntegerField(validators=[MinValueValidator(1), MaxValueValidator(5)])
    rate_reduction_risque = models.IntegerField(validators=[MinValueValidator(1), MaxValueValidator(5)])
    rate_maitrise_metier = models.IntegerField(validators=[MinValueValidator(1), MaxValueValidator(5)])
    taux_satisfaction = models.CharField(max_length=50)
   

    class Meta:
        verbose_name = "Évaluation à froid"
        verbose_name_plural = "Évaluations à froid"

    def __str__(self):
        return f"Évaluation {self.evaluation_id} - {self.orienter} - {self.date}"


class Evaluerchaud(models.Model):
    orienter = models.ForeignKey(Orienter, on_delete=models.CASCADE)
    evaluateur = models.ForeignKey(Evaluateur, on_delete=models.CASCADE)
    date_evaluation = models.DateField(blank=False, null=False)
    objectifs = models.CharField(max_length=100)
    contenu = models.CharField(max_length=100)
    equilibre = models.CharField(max_length=100)
    documentation = models.CharField(max_length=100)
    methodes = models.CharField(max_length=100)
    communication = models.CharField(max_length=100)
    adaptation = models.CharField(max_length=100)
    participation = models.CharField(max_length=100)
    interet = models.CharField(max_length=100)
    duree = models.CharField(max_length=100)
    local = models.CharField(max_length=100)
    moyens = models.CharField(max_length=100)
    comprehension = models.CharField(max_length=100)
    applicables = models.CharField(max_length=100)
    satisfaction = models.CharField(max_length=100)
    recommendation = models.CharField(max_length=100)
    
    EVALUATION_CHOICES = {
        'tres_satisfait': 4,
        'satisfait': 3,
        'peu_satisfait': 2,
        'insatisfait': 1,
    }

    def get_evaluation_value(self, field_name):
        value = getattr(self, field_name, 'insatisfait')
        return self.EVALUATION_CHOICES.get(value, 1)

    def calculate_taux_evaluation(self):
        fields = [
            'objectifs', 'contenu', 'equilibre', 'documentation', 'methodes',
            'communication', 'adaptation', 'participation', 'interet', 'duree',
            'local', 'moyens', 'comprehension', 'applicables', 'satisfaction', 'recommendation'
        ]
        
        total_value = sum(self.get_evaluation_value(field) for field in fields)
        average_value = total_value / len(fields)
        taux_evaluation = (average_value / 4) * 100  # Convert to percentage

        return taux_evaluation

    @property
    def taux_evaluation(self):
        return self.calculate_taux_evaluation()

    def __str__(self):
        return f"Évaluation de la formation : {self.objectifs} - {self.contenu}"
