import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackbuddy/Screens/page_shell.dart';

import '../Components/button.dart';
import '../Components/group_card.dart';
import '../Components/heading.dart';
import '../Components/input_field.dart';
import '../Components/theme.dart';
import '../Database/placeholder.dart';
import 'groupchat.dart';
import 'lecturer_search.dart';

class StudyGroupsPage extends StatefulWidget {
  const StudyGroupsPage({super.key});

  @override
  State<StudyGroupsPage> createState() => _StudyGroupsPageState();
}

class _StudyGroupsPageState extends State<StudyGroupsPage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  // --- Method Keluar / Hapus Grup ---
  Future<void> _handleLeaveOrDelete(String docId, Map<String, dynamic> data) async {
    final userEmail = currentUser?.email ?? 'Anonymous';
    final String createdBy = data['createdBy'] ?? '';
    final List<dynamic> members = List.from(data['members'] ?? []);
    final bool isCreator = createdBy == userEmail;

    if (isCreator || members.length <= 1) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Hapus Kelompok Belajar',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16)),
          content: Text(isCreator
              ? 'Sebagai pembuat, apakah kamu yakin ingin menghapus kelompok belajar ini?'
              : 'Karena kamu adalah anggota terakhir, keluar dari grup akan menghapus kelompok belajar ini secara otomatis. Lanjutkan?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () async {
                Navigator.pop(ctx);
                try {
                  await FirebaseFirestore.instance.collection('study_groups').doc(docId).delete();
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kelompok belajar berhasil dihapus.')),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menghapus grup: $e'), backgroundColor: Colors.red),
                  );
                }
              },
              child: const Text('Hapus'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      members.remove(userEmail);
      await FirebaseFirestore.instance.collection('study_groups').doc(docId).update({
        'members': members,
        'joined': members.length,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kamu telah keluar dari kelompok belajar.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal keluar dari grup: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // --- Method Gabung Grup ---
  Future<void> _joinGroup(String docId, Map<String, dynamic> data) async {
    final userEmail = currentUser?.email ?? 'Anonymous';
    final List<dynamic> members = List.from(data['members'] ?? []);
    final int capacity = data['capacity'] ?? 5;

    if (members.contains(userEmail)) return;

    try {
      if (members.length < capacity) {
        members.add(userEmail);
        await FirebaseFirestore.instance.collection('study_groups').doc(docId).update({
          'members': members,
          'joined': members.length,
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kelompok belajar sudah penuh!')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal bergabung: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // --- Method Dialog Lihat Daftar Anggota ---
  void _showMembersDialog(List<dynamic> members) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Daftar Anggota (${members.length})',
            style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: members.length,
            itemBuilder: (_, index) {
              return ListTile(
                leading: const Icon(Icons.person_rounded, color: C.maroon),
                title: Text(members[index], style: const TextStyle(fontSize: 14)),
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
        ],
      ),
    );
  }

  // --- Navigasi ke Halaman Chat Kelompok ---
  void _openChatRoom(String groupId, String courseName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupChatPage(groupId: groupId, courseName: courseName),
      ),
    );
  }

  // --- Method Buat Kelompok Baru dengan Pilihan Waktu Selesai ---
  void _create() {
    final course = TextEditingController();
    final place = TextEditingController();
    final note = TextEditingController();
    String tag = 'UTS';

    // Default waktu belajar selesai 2 jam dari sekarang
    TimeOfDay selectedEndTime = TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 2)));
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text('Buat Kelompok Belajar',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: course, decoration: fieldDecoration('Nama mata kuliah')),
                const SizedBox(height: 8),
                TextField(controller: place, decoration: fieldDecoration('Lokasi')),
                const SizedBox(height: 8),
                TextField(controller: note, maxLines: 2, decoration: fieldDecoration('Keterangan')),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: tag,
                  decoration: fieldDecoration('Jenis'),
                  items: const ['UTS', 'UAS', 'Tugas', 'Kuis']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setLocal(() => tag = v ?? tag),
                ),
                const SizedBox(height: 12),
                // Pemilih Waktu Selesai Belajar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Selesai Belajar:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: () async {
                        final TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: selectedEndTime,
                        );
                        if (time != null) {
                          setLocal(() => selectedEndTime = time);
                        }
                      },
                      icon: const Icon(Icons.access_time_rounded, size: 16),
                      label: Text(selectedEndTime.format(context)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            ElevatedButton(
              style: darkButton(radius: 8),
              onPressed: () async {
                final courseName = course.text.trim();
                if (courseName.isEmpty) return;

                final userEmail = currentUser?.email ?? 'Anonymous';

                // Gabungkan tanggal hari ini dengan waktu selesai yang dipilih
                final DateTime endDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedEndTime.hour,
                  selectedEndTime.minute,
                );

                Navigator.pop(ctx);

                try {
                  await FirebaseFirestore.instance.collection('study_groups').add({
                    'course': courseName,
                    'place': place.text.trim().isEmpty ? 'Lokasi menyusul' : place.text.trim(),
                    'schedule': 'Hari ini · ${selectedEndTime.format(context)} selesai',
                    'note': note.text.trim().isEmpty ? 'Belum ada keterangan.' : note.text.trim(),
                    'tag': tag,
                    'joined': 1,
                    'capacity': 5,
                    'createdBy': userEmail,
                    'members': [userEmail],
                    'timestamp': FieldValue.serverTimestamp(),
                    'endTimestamp': Timestamp.fromDate(endDateTime), // Simpan batas waktu kadaluarsa
                  });

                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kelompok belajar berhasil dibuat!')),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal membuat kelompok: $e'), backgroundColor: Colors.red),
                  );
                }
              },
              child: const Text('Buat'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = currentUser?.email ?? 'Anonymous';
    final now = DateTime.now();

    return PageShell(
      showBack: true,
      fab: FloatingActionButton(
        onPressed: _create,
        backgroundColor: C.maroon,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Heading('Hari ini mau belajar apa?', 'Mending pusingnya bareng-bareng'),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('study_groups')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
                }

                final docs = snapshot.data?.docs ?? [];

                // Ganti bagian if (docs.isEmpty) di dalam build() kelas StudyGroupsPage dengan ini:
                if (docs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: C.maroon.withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.groups_rounded,
                              size: 64,
                              color: C.maroon,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada kelompok belajar nih...',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Yuk, buat kelompok belajar baru atau tunggu temanmu membuat sesi!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Tombol Utama: Buat Kelompok Baru
                          ElevatedButton.icon(
                            onPressed: _create,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: C.maroon,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: Text(
                              'Buat Kelompok Baru',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Tombol Kedua (Hollow & Lebih Kecil): Pintasan ke Halaman Cek/Konfirmasi Dosen
                          OutlinedButton.icon(
                            onPressed: () {
                              // Navigasi kembali atau pindah ke halaman LecturerSearchPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LecturerSearchPage(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: C.maroon,
                              side: const BorderSide(color: C.maroon, width: 1),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.person_search_rounded, size: 15),
                            label: Text(
                              'Bantu Konfirmasi Kehadiran Dosen',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Filter dokumen secara lokal: hapus/abaikan grup yang waktu 'endTimestamp'-nya sudah lewat
                final activeDocs = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final Timestamp? endTimestamp = data['endTimestamp'] as Timestamp?;

                  if (endTimestamp == null) return true; // Jika data lama belum ada endTimestamp, tetap tampilkan

                  // Jika waktu sekarang masih sebelum waktu selesai, berarti grup masih aktif
                  return endTimestamp.toDate().isAfter(now);
                }).toList();

                if (activeDocs.isEmpty) {
                  return const Center(
                    child: Text('Semua kelompok belajar hari ini telah selesai.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 96, top: 4),
                  itemCount: activeDocs.length,
                  itemBuilder: (_, i) {
                    final doc = activeDocs[i];
                    final data = doc.data() as Map<String, dynamic>;

                    final String createdBy = data['createdBy'] ?? 'Unknown';
                    final List<dynamic> members = data['members'] ?? [];
                    final bool isMember = members.contains(userEmail);
                    final String courseName = data['course'] ?? '';

                    final group = StudyGroup(
                      course: courseName,
                      place: data['place'] ?? '',
                      schedule: data['schedule'] ?? '',
                      note: data['note'] ?? '',
                      tag: data['tag'] ?? 'UTS',
                      joined: members.isNotEmpty ? members.length : (data['joined'] ?? 1),
                      capacity: data['capacity'] ?? 5,
                      isMine: isMember,
                      createdBy: createdBy,
                      members: members,
                    );

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Stack(
                        children: [
                          GroupCard(
                            group: group,
                            onToggle: () {
                              if (isMember) {
                                _handleLeaveOrDelete(doc.id, data);
                              } else {
                                _joinGroup(doc.id, data);
                              }
                            },
                          ),
                          Positioned(
                            top: 12,
                            right: 90,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (isMember) {
                                      _openChatRoom(doc.id, courseName);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Gabung ke grup terlebih dahulu untuk membuka chat!')),
                                      );
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: isMember ? C.maroon.withOpacity(0.1) : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: isMember ? C.maroon.withOpacity(0.3) : Colors.grey.shade300, width: 0.5),
                                    ),
                                    child: Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      size: 14,
                                      color: isMember ? C.maroon : Colors.grey,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                InkWell(
                                  onTap: () => _showMembersDialog(members),
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey.shade300, width: 0.5),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.people_outline_rounded, size: 13, color: Colors.black87),
                                        const SizedBox(width: 3),
                                        Text(
                                          '${members.length}/${group.capacity}',
                                          style: const TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
