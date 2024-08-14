class InformationFile {
  String? Objectif; //elle est immodifiable
  String reponse; //elle est modifiable

  InformationFile({ this.Objectif, this.reponse="" });
}

List<InformationFile> demoInformationFiles = [
  InformationFile(
  
    Objectif: "Intitulé de la formation ",
    reponse: "",
  
  ),
  InformationFile(
   Objectif: "Date de la realisation de la formation  ",
    reponse: "",
 
  ),
  InformationFile(
   Objectif: "Date de l'evaluation a froid ",
   reponse: "",
 
  ),

  InformationFile(
   Objectif: "Categorie de la formation ",
   reponse: "",
  
  ),

  
 
];