class Tugas {
  String judul;
  String deskripsi;
  DateTime deadline;
  String prioritas;
  bool selesai;

  Tugas({
    required this.judul,
    required this.deskripsi,
    required this.deadline,
    required this.prioritas,
    this.selesai = false,
  });
}