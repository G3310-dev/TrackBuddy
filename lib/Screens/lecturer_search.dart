import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackbuddy/Screens/page_shell.dart';

import '../Components/button.dart';
import '../Components/heading.dart';
import '../Components/input_field.dart';
import '../Components/result.dart';
import '../Components/theme.dart';
import '../Database/placeholder.dart';

class LecturerSearchPage extends StatefulWidget {
  const LecturerSearchPage({super.key});

  @override
  State<LecturerSearchPage> createState() => _LecturerSearchPageState();
}

class _LecturerSearchPageState extends State<LecturerSearchPage> {
  final _nameController = TextEditingController();
  final _deptController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _deptController.dispose();
    super.dispose();
  }

  // Helper untuk mengecek validitas status harian dan memformat tanggal & waktu dari Timestamp Firestore
  Map<String, dynamic> _resolveDailyStatus(Map<String, dynamic>? reportData) {
    if (reportData == null) {
      return {'present': false, 'info': 'Belum ada laporan hari ini'};
    }

    final Timestamp? timestamp = reportData['timestamp'] as Timestamp?;
    if (timestamp == null) {
      return {'present': false, 'info': reportData['info'] ?? 'Belum ada informasi waktu'};
    }

    final reportDate = timestamp.toDate();
    final now = DateTime.now();
    final isToday = reportDate.year == now.year &&
        reportDate.month == now.month &&
        reportDate.day == now.day;

    // Array nama bulan singkat dalam bahasa Indonesia
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final dayStr = reportDate.day.toString();
    final monthStr = months[reportDate.month - 1];
    final yearStr = reportDate.year.toString();
    final timeStr = '${reportDate.hour.toString().padLeft(2, '0')}:${reportDate.minute.toString().padLeft(2, '0')}';

    // Format lengkap: "13 Nov 2026, 12:21"
    final formattedDateTime = '$dayStr $monthStr $yearStr, $timeStr';
    final location = reportData['location'] ?? 'Lokasi tidak diketahui';

    if (isToday) {
      return {
        'present': true,
        'info': 'Terlihat di $location ($formattedDateTime)',
      };
    } else {
      // Jika sudah berganti hari, tetap tampilkan kapan terakhir kali beliau terlihat tapi status jadi tidak hadir
      return {
        'present': false,
        'info': 'Terakhir terlihat: $formattedDateTime (Reset harian)',
      };
    }
  }

  // --- Method Pencarian ---
  Future<void> _searchLecturers() async {
    final nameQuery = _nameController.text.trim().toLowerCase();
    final deptQuery = _deptController.text.trim().toLowerCase();

    setState(() => _isLoading = true);

    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('lecturer_reports').get();

      final Map<String, Map<String, dynamic>> reportMap = {};
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final nameKey = (data['lecturerName'] ?? '').toString().trim().toLowerCase();
        if (nameKey.isNotEmpty) {
          reportMap[nameKey] = data;
        }
      }

      final matchedPlaceholders = lecturers.where((l) {
        final matchName = l.name.toLowerCase().contains(nameQuery);
        final matchDept = l.department.toLowerCase().contains(deptQuery);
        return matchName && matchDept;
      }).toList();

      final results = matchedPlaceholders.map((placeholderLecturer) {
        final key = placeholderLecturer.name.toLowerCase();
        final resolved = _resolveDailyStatus(reportMap[key]);

        return Lecturer(
          placeholderLecturer.name,
          placeholderLecturer.department,
          resolved['present'],
          resolved['info'],
        );
      }).toList();

      if (!mounted) return;

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (_) => ResultsSheet(results: results),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mencari data: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- Method Kirim Laporan ke Firestore ---
  void _reportLecturer() {
    String? selectedLecturerName = lecturers.isNotEmpty ? lecturers.first.name : null;
    final reportLocController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Laporan Kehadiran Dosen',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pilih Dosen dari Daftar:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedLecturerName,
                        isExpanded: true,
                        items: lecturers.map((Lecturer l) {
                          return DropdownMenuItem<String>(
                            value: l.name,
                            child: Text(l.name, style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setDialogState(() {
                            selectedLecturerName = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: reportLocController,
                    decoration: fieldDecoration('Lokasi/Gedung (mis. Gedung K)'),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                ElevatedButton(
                  style: darkButton(radius: 8),
                  onPressed: () async {
                    final location = reportLocController.text.trim();

                    if (selectedLecturerName == null || location.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pilih dosen dan isi lokasi dengan lengkap!')),
                      );
                      return;
                    }

                    Navigator.pop(ctx);

                    try {
                      // Simpan riwayat laporan ke koleksi 'lecturer_reports' dengan server timestamp
                      await FirebaseFirestore.instance.collection('lecturer_reports').add({
                        'lecturerName': selectedLecturerName,
                        'location': location,
                        'timestamp': FieldValue.serverTimestamp(),
                      });

                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Laporan kehadiran berhasil dikirim!')),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal mengirim laporan: $e'), backgroundColor: Colors.red),
                      );
                    }
                  },
                  child: const Text('Kirim'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageShell(
      showBack: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Heading('Siapa yang kamu cari?', 'Beliau ada gak ya...'),
            const SizedBox(height: 32),
            const Center(
              child: Icon(Icons.search_rounded, size: 190, color: C.maroon),
            ),
            const SizedBox(height: 40),
            TextField(controller: _nameController, decoration: fieldDecoration('Nama Dosen')),
            const SizedBox(height: 8),
            TextField(controller: _deptController, decoration: fieldDecoration('Departemen')),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _searchLecturers,
                style: ElevatedButton.styleFrom(
                  backgroundColor: C.maroon,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : const Text('Cari'),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _reportLecturer,
                style: darkButton(radius: 10).copyWith(
                    padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 2)),
                    textStyle: WidgetStatePropertyAll(
                        GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500))),
                child: const Text('Laporan Pencarian'),
              ),
            ),
            const SizedBox(height: 24),

            // Daftar Status Kehadiran Real-time dari Koleksi 'lecturer_reports'
            const Text(
              'Status Kehadiran Dosen Hari Ini:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('lecturer_reports').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Petakan laporan berdasarkan nama dosen
                final Map<String, Map<String, dynamic>> reportMap = {};
                if (snapshot.hasData) {
                  for (var doc in snapshot.data!.docs) {
                    final data = doc.data() as Map<String, dynamic>;
                    final key = (data['lecturerName'] ?? '').toString().trim().toLowerCase();
                    if (key.isNotEmpty) {
                      reportMap[key] = data;
                    }
                  }
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: lecturers.length,
                  itemBuilder: (context, index) {
                    final l = lecturers[index];
                    final resolved = _resolveDailyStatus(reportMap[l.name.toLowerCase()]);
                    final bool isPresent = resolved['present'];
                    final String info = resolved['info'];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        title: Text(l.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l.department, style: const TextStyle(fontSize: 11)),
                            const SizedBox(height: 2),
                            Text(
                              info,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: isPresent ? Colors.green.shade700 : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isPresent ? Colors.green.shade100 : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isPresent ? 'Hadir' : 'Tidak Hadir',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isPresent ? Colors.green.shade800 : Colors.red.shade800,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}