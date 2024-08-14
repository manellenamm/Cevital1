class EvaluationFile {
  String? Objectif; //elle est immodifiable
  String rate; //elle est modifiable
  String evaluation; //elle est modifiable

  EvaluationFile({ this.Objectif, this.rate="", this.evaluation=""});
}

List<EvaluationFile> demoEvaluationFiles = [
  EvaluationFile(
  
    Objectif: "La formation choisie semblait-elle répondre à son besoin ?",
    rate: "",
    evaluation: "",
  
  ),
  EvaluationFile(
   Objectif: "Pensez-vous que votre collaborateur a atteint les objectifs de la formation ? ",
   rate: "",
  evaluation: "",
  ),
  EvaluationFile(
   Objectif: "Votre collaboratur a pu mettre en pratique les connaissances acquises ?",
   rate: "",
  evaluation: "",
  ),

  EvaluationFile(
   Objectif: "La formation a-elle permis a votre collaborateur de réduire les requises de NC ou d'accidents ?",
   rate: "",
  evaluation: "",
  ),

  EvaluationFile(
   Objectif: "La formation a-elle permis a votre collaborateur une meuilleure métrise du métier/des régles QHSE",
   rate: "",
  evaluation: "",
  ),
 
];