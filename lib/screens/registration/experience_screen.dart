import 'package:flutter/material.dart';

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  String _experienceLevel = 'Beginner';

  @override
  Widget build(BuildContext context) {
    // Get the arguments passed from the previous screen, with a null check
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // If arguments are not null and 'experience' is available, set it to _experienceLevel
    if (args != null && args['experience'] != null) {
      _experienceLevel = args['experience'];
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Experience Level')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _experienceLevel,
              items: ['Beginner', 'Intermediate', 'Advanced'].map((level) {
                return DropdownMenuItem(value: level, child: Text(level));
              }).toList(),
              onChanged: (val) => setState(() => _experienceLevel = val!),
              decoration: const InputDecoration(labelText: 'Select level'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Merge existing arguments with the new experience level
                Navigator.pushNamed(
                  context,
                  '/issues',
                  arguments: {
                    ...?args, // Spread the existing arguments (if any)
                    'experience': _experienceLevel
                  },
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
