import json
from datetime import datetime
from django.core.management.base import BaseCommand
from Cevital.models import Effectif, Formation, Orienter, Datee

def parse_date(date_str):
    if date_str:
        try:
            return datetime.strptime(date_str, '%d/%m/%Y').date()  # Modification du format de date
        except ValueError:
            return None
    return None

class Command(BaseCommand):
    help = 'Import JSON data into the database'

    def handle(self, *args, **kwargs):
        json_file_path = 'Cevital/rr.json'
        
        try:
            with open(json_file_path, 'r') as file:
                data = json.load(file)
        except FileNotFoundError:
            self.stdout.write(self.style.ERROR(f'Le fichier {json_file_path} est introuvable.'))
            return
        except json.JSONDecodeError:
            self.stdout.write(self.style.ERROR('Erreur de décodage du fichier JSON.'))
            return

        for record in data:
            matricule = record.get("1")
            nom = record.get("Nom")
            prenom = record.get("Prenom")
            date_de_naissance = parse_date(record.get("DATE DE NAISSANCE"))  # Assurez-vous que la clé est correcte
            structure = record.get("Structure ")
            service = record.get("Service")
            fonction = record.get("Fonction")
            pole = record.get("Pole")
            csp = record.get("CSP").lower()  # Assurez-vous que CSP est en minuscule et correspond aux choix
            intitule = record.get("Intitulé  Action de formation ")
            if not intitule:
                self.stdout.write(self.style.ERROR('Intitulé de formation manquant dans les données JSON'))
            if not date_de_naissance:
                date_de_naissance = datetime.today().date()  # Valeur par défaut

            # Création ou récupération de l'Effectif
            effectif, created = Effectif.objects.get_or_create(
                matricule=matricule,
                defaults={
                    'nom': nom,
                    'prenom': prenom,
                    'date_de_naissance': date_de_naissance,
                    'structure': structure,
                    'service': service,
                    'fonction': fonction,
                    'pole': pole,
                    'csp': csp,
                    'matricule' : matricule
                }
            )

            # Création ou mise à jour des objets Datee
            date_debut = parse_date(record.get("DATE DEBUT REELLE"))
            date_fin = parse_date(record.get("DATE FIN REELLE"))

            if date_debut:
                date_debut_obj, created = Datee.objects.get_or_create(date=date_debut)
            if date_fin:
                date_fin_obj, created = Datee.objects.get_or_create(date=date_fin)

            # Création ou mise à jour des objets Formation
            formation, created = Formation.objects.get_or_create(
                intitule=record.get("Intitulé  Action de formation "),
                defaults={
                    'formateur': None,  # assuming formateur is not provided in the JSON
                }
            )

            # Création ou mise à jour des objets Orienter
            orienter, created = Orienter.objects.get_or_create(
                formation=formation,
                date_debut=date_debut_obj,
                date_fin=date_fin_obj,
                sous_groupe=None,  # assuming sous_groupe is not provided in the JSON
                organisme_formation=record.get("Organisme de formation"),
                code_tiers=record.get("Code Tiers").strip(),
                lieu_formation='',
                type_formation=record.get("Type de formation2"),
                categorie_formation=record.get("Catégorie de formation2"),
                responsable_hiearchique=None,  # assuming responsable_hiearchique is not provided in the JSON
                cout_total=record.get("Coût total pédagogique (TTC)"),
                NumBc=record.get("N° BC"),
                Facture_Pédagogique=record.get("N° Facture pédagogique"),
                NuméroFacture_Pédagogique=record.get("N° Facture pédagogique"),
                Organisme_logistique=record.get("Organisme Logistique"),
                Facture_Hotel=record.get("N° Facture Hotel"),
                cout_logistique=record.get("coût logistique par Groupe TTC"),
                Enjeu=record.get("ENJEU"),
            )

        self.stdout.write(self.style.SUCCESS('Données importées avec succès!'))
