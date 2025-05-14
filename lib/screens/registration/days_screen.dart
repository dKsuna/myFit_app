import 'package:flutter/material.dart';

class DaysScreen extends StatefulWidget {
  const DaysScreen({super.key});

  @override
  State<DaysScreen> createState() => _DaysScreenState();
}

class _DaysScreenState extends State<DaysScreen> {
  List<String> _selectedDays = [];
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: const Text('Workout Days')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._days.map((day) => CheckboxListTile(
                title: Text(day),
                value: _selectedDays.contains(day),
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      _selectedDays.add(day);
                    } else {
                      _selectedDays.remove(day);
                    }
                  });
                },
              )),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/equipment', // Navigating to the EquipmentScreen
                arguments: {
                  ...args,
                  'days':
                      _selectedDays // Passing the selected days as a simple list
                },
              );
            },
            child: const Text('Next'),
          )
        ],
      ),
    );
  }
}
