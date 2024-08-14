import json
from datetime import datetime
from django.core.management.base import BaseCommand
from Cevital.models import Effectif

class Command(BaseCommand):
    help = 'Import JSON data into the database'

    def handle(self, *args, **kwargs):
        json_file_path = 'Cevital/ss.json'
        
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
            # Extraire et nettoyer les données du JSON
            matricule = record.get("Matricule", "").strip()
            nom = record.get("Nom", "").strip()
            prenom = record.get("Prenom", "").strip()
            self.stdout.write(self.style.SUCCESS(f'Extraction du prénom: {prenom}'))
            date_de_naissance_str = record.get("Date de naissance", "").strip()
            structure = record.get("Unité/Direction", "").strip()
            service = record.get("Département/ Service", "").strip()
            pole = record.get("Pole", "").strip()
            csp = record.get("CSP", "").strip().lower()
            fonction = record.get("Fonction", "").strip()
            email = record.get("Email", "").strip() or "pas_d_email@example.com"  # Valeur par défaut

            # Convertir la date de naissance au format attendu
            try:
                date_de_naissance = datetime.strptime(date_de_naissance_str, "%d/%m/%Y").date()
            except ValueError:
                self.stdout.write(self.style.ERROR(f'Erreur de format de date pour {nom} {prenom}. Date de naissance invalide.'))
                continue

            # Créer ou mettre à jour les objets Effectif
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
                    'email': email,
                }
            )

            if not created:
                # Si l'effectif existe déjà, mettre à jour les champs si nécessaire
                effectif.nom = nom
                effectif.prenom = prenom
                effectif.date_de_naissance = date_de_naissance
                effectif.structure = structure
                effectif.service = service
                effectif.fonction = fonction
                effectif.pole = pole
                effectif.csp = csp
                effectif.email = email
                effectif.matricule=matricule
                effectif.save()

        self.stdout.write(self.style.SUCCESS('Données importées avec succès!'))
