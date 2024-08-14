class ResponsableFile {
  String? Objectif; //elle est immodifiable
  String reponse; //elle est modifiable

  ResponsableFile({ this.Objectif, this.reponse="" });
}

List<ResponsableFile> demoResponsableFiles = [
  ResponsableFile(
  
    Objectif: "Matricule",
    reponse: "",
  
  ),
 ResponsableFile(
   Objectif: "Nom ",
    reponse: "",
 
  ),
  ResponsableFile(
   Objectif: "Prenom ",
   reponse: "",
 
  ),

  

  
 
];