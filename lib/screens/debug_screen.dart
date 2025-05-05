import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'db/db_helper.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  Future<void> _requestPermissions() async {
    // Request storage permissions
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Proceed with the copy operation if permission is granted
      await DBHelper.copyDatabaseToDownloads();
    } else {
      // Show a message if permission is denied
      print('Storage permission denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Tools'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _requestPermissions(); // Request permissions and then copy DB
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Database copied to Downloads!')),
            );
          },
          child: const Text('Copy DB to Downloads 📂'),
        ),
      ),
    );
  }
}
