import 'package:flutter/material.dart';
import 'trip.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  int _days = 1;
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'พักผ่อน';

  List<String> categories = ['พักผ่อน', 'ทำงาน', 'ธุระส่วนตัว'];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Trip newTrip = Trip(
        title: _title,
        days: _days,
        date: _selectedDate,
        category: _selectedCategory,
      );
      Navigator.pop(context, newTrip);
    }
  }

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เพิ่มแผนการเดินทาง')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'ชื่อแผนการเดินทาง'),
                validator: (value) => value!.isEmpty ? 'โปรดป้อนชื่อ' : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'จำนวนวัน'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty || int.tryParse(value) == null ? 'โปรดป้อนตัวเลข' : null,
                onSaved: (value) => _days = int.parse(value!),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('วันที่: ${_selectedDate.toLocal()}'.split(' ')[0]),
                  TextButton(onPressed: _pickDate, child: Text('เลือกวันที่'))
                ],
              ),
              DropdownButtonFormField(
                value: _selectedCategory,
                items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value as String),
                decoration: InputDecoration(labelText: 'หมวดหมู่'),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submitForm, child: Text('บันทึก'))
            ],
          ),
        ),
      ),
    );
  }
}
