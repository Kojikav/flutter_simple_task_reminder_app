import 'package:flutter/material.dart';
import '../models/tugas.dart';

class AddTaskScreen extends StatefulWidget {
  final Tugas? existingTugas;

  const AddTaskScreen({super.key, this.existingTugas});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _judulController = TextEditingController();
  final _deskripsiController = TextEditingController();
  DateTime? _selectedDeadline;
  String _selectedPrioritas = 'Sedang';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.existingTugas != null) {
      _judulController.text = widget.existingTugas!.judul;
      _deskripsiController.text = widget.existingTugas!.deskripsi;
      _selectedDeadline = widget.existingTugas!.deadline;
      _selectedPrioritas = widget.existingTugas!.prioritas;
    }
  }

  Future<void> _pickDeadline() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDeadline) {
      setState(() {
        _selectedDeadline = picked;
      });
    }
  }

  void _simpanTugas() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDeadline == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Deadline harus dipilih!')),
        );
        return;
      }

      if (widget.existingTugas != null) {
        setState(() {
          widget.existingTugas!.judul = _judulController.text;
          widget.existingTugas!.deskripsi = _deskripsiController.text;
          widget.existingTugas!.deadline = _selectedDeadline!;
          widget.existingTugas!.prioritas = _selectedPrioritas;
        });
        Navigator.pop(context, 'edited');
      } else {
        final tugasBaru = Tugas(
          judul: _judulController.text,
          deskripsi: _deskripsiController.text,
          deadline: _selectedDeadline!,
          prioritas: _selectedPrioritas,
        );
        Navigator.pop(context, tugasBaru);
      }
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingTugas != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Tugas' : 'Tambah Tugas Baru'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _judulController,
                decoration: InputDecoration(
                  labelText: 'Judul Tugas',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deskripsiController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDeadline,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Deadline',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _selectedDeadline == null
                        ? 'Pilih Tanggal Deadline'
                        : '${_selectedDeadline!.day}/${_selectedDeadline!.month}/${_selectedDeadline!.year}',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedDeadline == null ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPrioritas,
                decoration: InputDecoration(
                  labelText: 'Prioritas',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.flag),
                ),
                items: ['Tinggi', 'Sedang', 'Rendah']
                    .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPrioritas = value!;
                  });
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _simpanTugas,
                icon: Icon(isEditing ? Icons.save : Icons.add_task),
                label: Text(
                  isEditing ? 'Simpan Perubahan' : 'Simpan Tugas',
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}