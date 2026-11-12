class Lecturer {
  final String name;
  final String department;
  final bool present;
  final String info;
  const Lecturer(this.name, this.department, this.present, this.info);
}

const lecturers = <Lecturer>[
  Lecturer('Dr. Budi Santoso', 'Metalurgi dan Material', true,
      'Terlihat di Gedung DTMM, 20 menit lalu (3 laporan)'),
  Lecturer('Prof. Siti Rahmawati', 'Teknik Kimia', false,
      'Belum ada laporan hari ini'),
  Lecturer('Ir. Andi Wijaya', 'Teknik Mesin', true,
      'Terlihat di ruang dosen, 1 jam lalu (2 laporan)'),
  Lecturer('Dr. Maya Putri', 'Fisika', false,
      'Terakhir terlihat kemarin sore di ICELL'),
  Lecturer('Dr. Rizky Pratama', 'Teknik Elektro', true,
      'Terlihat di Perpustakaan Pusat, 5 menit lalu (4 laporan)'),
];

class StudyGroup {
  final String course;
  final String place;
  final String schedule;
  final String note;
  final String tag;
  int joined;
  final int capacity;
  bool isMine;
  final String createdBy;       // Menyimpan siapa yang buat
  final List<dynamic> members;  // List siapa saja yang ikut

  StudyGroup({
    required this.course,
    required this.place,
    required this.schedule,
    required this.note,
    required this.tag,
    required this.joined,
    this.capacity = 5,
    this.isMine = false,
    required this.createdBy,
    required this.members,
  });
}

// List<StudyGroup> buildGroups() => [
//   StudyGroup(
//     course: 'Fisika Dasar 1',
//     place: 'Deket ICELL',
//     schedule: '27/09/25 · 07.00-11.00',
//     note:
//     'Mau bahas soal latihan bab kalor dan termodinamika. Bawa catatan sendiri ya.',
//     tag: 'UTS',
//     joined: 2,
//   ),
//   StudyGroup(
//     course: 'Kalkulus 2',
//     place: 'Perpustakaan Pusat, lantai 2',
//     schedule: '28/09/25 · 13.00-16.00',
//     note: 'Fokus integral lipat dan deret. Santai, tapi serius.',
//     tag: 'UTS',
//     joined: 4,
//   ),
//   StudyGroup(
//     course: 'Kimia Dasar',
//     place: 'Selasar Gedung Teknik',
//     schedule: '29/09/25 · 09.00-12.00',
//     note: 'Ngerjain tugas stoikiometri bareng sebelum dikumpul.',
//     tag: 'Tugas',
//     joined: 5,
//   ),
// ];
