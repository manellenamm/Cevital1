class CloudStorageInfo {
  final String? title;
  final int?  percentage;
  final String? value;

  CloudStorageInfo({

    this.title,
    this.percentage,
    this.value,
  });
}

List demoMyFiles = [
  CloudStorageInfo(
    title: "Effectif",
    percentage: 35,
    value: "24",
  ),
  CloudStorageInfo(
    title: "Présence/jour" ,
    percentage: 35,
    value: "30",
  ),
  CloudStorageInfo(
    title: "Formation",
    percentage: 10,
    value: "10",
  ),
  CloudStorageInfo(
    title: "Effectif Evalué",
    percentage: 35,
    value: "29",
  ),
];
