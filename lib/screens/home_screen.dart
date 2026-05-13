import 'package:flutter/material.dart';
import '../models/tugas.dart';
import 'add_task_screen.dart';
import 'detail_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Tugas> _daftarTugas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder Tugas'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _daftarTugas.isEmpty
          ? const Center(
        child: Text(
          'Belum ada tugas.\nTekan + untuk menambahkan!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _daftarTugas.length,
        itemBuilder: (context, index) {
          final tugas = _daftarTugas[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(
                tugas.judul,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: tugas.selesai ? TextDecoration.lineThrough : TextDecoration.none,
                  color: tugas.selesai ? Colors.grey : Colors.black,
                ),
              ),
              subtitle: Text(
                '${tugas.prioritas} - ${tugas.deadline.day}/${tugas.deadline.month}/${tugas.deadline.year}',
              ),
              trailing: Icon(
                tugas.selesai ? Icons.check_circle : Icons.radio_button_unchecked,
                color: tugas.selesai ? Colors.green : Colors.orange,
              ),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailTaskScreen(
                      tugas: tugas,
                      index: index,
                    ),
                  ),
                );

                if (result != null) {
                  setState(() {
                    if (result == 'delete') {
                      _daftarTugas.removeAt(index);
                    } else if (result == 'toggle') {
                      _daftarTugas[index].selesai = !_daftarTugas[index].selesai;
                    } else if (result == 'edited') {
                      setState(() {});
                    }
                  });
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );

          if (result != null && result is Tugas) {
            setState(() {
              _daftarTugas.add(result);
            });
          }
        },
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}