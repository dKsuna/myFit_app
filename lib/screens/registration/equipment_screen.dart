import 'package:flutter/material.dart';

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({super.key});

  @override
  State<EquipmentScreen> createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {
  String _equipmentAccess = 'Bodyweight';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: const Text('Equipment Access')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _equipmentAccess,
              items: ['Bodyweight', 'Gym equipment'].map((equip) {
                return DropdownMenuItem(value: equip, child: Text(equip));
              }).toList(),
              onChanged: (val) => setState(() => _equipmentAccess = val!),
              decoration: const InputDecoration(labelText: 'Select equipment'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Pass selected equipment as a single item list in arguments
                Navigator.pushNamed(
                  context,
                  '/summary',
                  arguments: {...args, 'equipment': _equipmentAccess},
                );
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
