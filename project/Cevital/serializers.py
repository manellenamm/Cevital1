from rest_framework import serializers
from django.contrib.auth.models import User
from .models import *
class UserLoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)

    def validate(self, attrs):
        email = attrs.get('email')
        password = attrs.get('password')

        if email and password:
            # Recherchez l'utilisateur par email au lieu de username
            user = User.objects.filter(email=email).first()

            if user and user.check_password(password):
                attrs['user'] = user
            else:
                raise serializers.ValidationError('Invalid email or password.')
        else:
            raise serializers.ValidationError('Must include "email" and "password".')

        return attrs


class DateeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Datee
        fields = ['id_date', 'date']


class ParticFormaSerializer(serializers.ModelSerializer):
    class Meta:
        model = ParticipantFormation
        fields =  '__all__' 

class ParticipantFormationSerializer(serializers.ModelSerializer):
    participant_nom = serializers.CharField(source='participant.nom', read_only=True)
    participant_prenom = serializers.CharField(source='participant.prenom', read_only=True)
    participant_matricule = serializers.CharField(source='participant.matricule', read_only=True)
    participant_date_de_naissance = serializers.CharField(source='participant.date_de_naissance', read_only=True)

    class Meta:
        model = ParticipantFormation
        fields = [
            'id',
            'presence',
            'etat',
            'participant_nom',
            'participant_prenom',
            'participant_matricule',
            'participant_date_de_naissance',  # Corrected field name
            'orientation'
        ]

class FormationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Formation
        fields = '__all__' 
       

class DashboardSerializer(serializers.ModelSerializer):
    class Meta:
        model = Dashboard
        fields = '__all__'   

class DashboardBudjetSerializer(serializers.ModelSerializer):
    class Meta:
        model = Dashboardbudjets
        fields = '__all__'   

class OrienterSerializer(serializers.ModelSerializer):
    formation = FormationSerializer()
    date_debut = DateeSerializer()
    date_fin = DateeSerializer()
    

    class Meta:
        model = Orienter
        fields = '__all__' 






class FormateurSerializer(serializers.ModelSerializer):
    class Meta:
        model = Formateur
        fields = '__all__'

class EvaluerchaudSerializer(serializers.ModelSerializer):
    class Meta:
        model = Evaluerchaud
        fields = '__all__'


class EvaluerfroidSerializer(serializers.ModelSerializer):
    class Meta:
        model = Evaluerfroid
        fields = '__all__'



class CategorieSerializer(serializers.ModelSerializer):
    class Meta:
        model = Categorie
        fields = '__all__'


class EvaluerchaudSerializer(serializers.ModelSerializer):
    class Meta:
        model = Evaluerchaud
        fields = '__all__'  # Vous pouvez spécifier les champs si nécessaire

class SousgroupeSerializer(serializers.ModelSerializer):
    class Meta:
        model = SousGroupe
        fields = '__all__'

class ResponsableSerializer(serializers.ModelSerializer):
    class Meta:
        model = Responsable_hiearchique
        fields = '__all__'



class EffectifSerializer(serializers.ModelSerializer):
    class Meta:
        model = Effectif
        fields = '__all__'



class EvaluateurSerializer(serializers.ModelSerializer):
    class Meta:
        model = Evaluateur
        fields = '__all__'




# serializers.py
from rest_framework import serializers
from django.contrib.auth.models import User
from django.contrib.auth import authenticate

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'username', 'email')

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    password2 = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ('username', 'email', 'password', 'password2')

    def validate(self, data):
        if data['password'] != data['password2']:
            raise serializers.ValidationError({'password': 'Passwords must match.'})
        return data

    def create(self, validated_data):
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password']
        )
        return user
