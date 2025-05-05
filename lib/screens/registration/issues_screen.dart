import 'package:flutter/material.dart';

class IssuesScreen extends StatefulWidget {
  const IssuesScreen({super.key});

  @override
  State<IssuesScreen> createState() => _IssuesScreenState();
}

class _IssuesScreenState extends State<IssuesScreen> {
  List<String> _selectedIssues = [];
  final List<String> _issues = ['Knee pain', 'Back pain', 'Others', 'None'];

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(title: const Text('Physical Issues')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._issues.map((issue) => CheckboxListTile(
                title: Text(issue),
                value: _selectedIssues.contains(issue),
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      _selectedIssues.add(issue);
                    } else {
                      _selectedIssues.remove(issue);
                    }
                  });
                },
              )),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/days',
                  arguments: {...args, 'issues': _selectedIssues});
            },
            child: const Text('Next'),
          )
        ],
      ),
    );
  }
}
