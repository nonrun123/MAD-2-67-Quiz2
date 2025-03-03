import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_page.dart';
import 'trip.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Trip> trips = []; // เก็บข้อมูลแผนการเดินทาง

  void addTrip(Trip trip) {
    setState(() {
      trips.add(trip);
    });
  }

  void removeTrip(int index) {
    setState(() {
      trips.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'แผนการเดินทาง_App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: HomePage(trips: trips, addTrip: addTrip, removeTrip: removeTrip),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Trip> trips;
  final Function addTrip;
  final Function removeTrip;

  const HomePage({
    super.key,
    required this.trips,
    required this.addTrip,
    required this.removeTrip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '📍 แผนการเดินทางของคุณ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: trips.isEmpty
          ? const Center(
              child: Text(
                'ยังไม่มีแผนการเดินทาง\nเพิ่มแผนใหม่ได้เลย! 🚀',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: trips.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(trips[index].title),
                  onDismissed: (direction) => removeTrip(index),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: const Icon(Icons.travel_explore, size: 30, color: Colors.teal),
                      title: Text(
                        trips[index].title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '📅 ${DateFormat('dd/MM/yyyy').format(trips[index].date)}',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      trailing: Chip(
                        label: Text(
                          trips[index].category,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.teal,
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("เพิ่มแผนใหม่"),
        onPressed: () async {
          final newTrip = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPage()),
          );
          if (newTrip != null) addTrip(newTrip);
        },
        backgroundColor: Colors.teal,
      ),
    );
  }
}
