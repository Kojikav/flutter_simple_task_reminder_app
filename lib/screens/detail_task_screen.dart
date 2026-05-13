import 'package:flutter/material.dart';
import '../models/tugas.dart';
import 'add_task_screen.dart';

class DetailTaskScreen extends StatelessWidget {
  final Tugas tugas;
  final int index;

  const DetailTaskScreen({super.key, required this.tugas, required this.index});

  Color _getPrioritasColor(String prioritas) {
    switch (prioritas) {
      case 'Tinggi':
        return Colors.red;
      case 'Sedang':
        return Colors.orange;
      case 'Rendah':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tugas.judul,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Chip(
                        label: Text(
                          tugas.selesai ? 'Selesai' : 'Belum Selesai',
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: tugas.selesai ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(
                          tugas.prioritas,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: _getPrioritasColor(tugas.prioritas),
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  const Text(
                    'Deskripsi:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tugas.deskripsi,
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Deadline
                  Row(
                    children: [
                      const Icon(Icons.event, color: Colors.indigo),
                      const SizedBox(width: 8),
                      Text(
                        'Deadline: ${tugas.deadline.day}/${tugas.deadline.month}/${tugas.deadline.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),


          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context, 'delete');
                    },
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text('Hapus', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context, 'toggle');
                    },
                    icon: Icon(
                      tugas.selesai ? Icons.undo : Icons.check_circle,
                      size: 18,
                    ),
                    label: Text(
                      tugas.selesai ? 'Batalkan' : 'Selesai',
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: tugas.selesai ? Colors.orange : Colors.green,
                      side: BorderSide(
                        color: tugas.selesai ? Colors.orange : Colors.green,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddTaskScreen(existingTugas: tugas),
                        ),
                      );
                      if (result == 'edited') {
                        Navigator.pop(context, 'edited');
                      }
                    },
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}