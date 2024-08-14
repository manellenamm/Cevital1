class RecentFile {
  final String?  title, date, size, formateurs;

  RecentFile({ this.title, this.date, this.size, this.formateurs});
}

List<RecentFile> demoRecentFiles = [
  RecentFile(
  
    title: "Marketing",
    date: "01-03-2024",
    size: "01-04-2024",
    formateurs: "John Doe",
  ),
  RecentFile(
    title: "Developpement",
    date: "27-02-2021",
    size: "24-03-2024",
    formateurs: "Jane Smith",
  ),
 
];