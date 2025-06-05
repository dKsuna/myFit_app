import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  const ProfileScreen({super.key, required this.userName});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DBHelper _dbHelper = DBHelper();
  Map<String, dynamic>? _userDetails;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final user = await _dbHelper.getUserByName(widget.userName);
      setState(() {
        _userDetails = user;
      });
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
      ),
      body: _userDetails == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _profileItem('Name', _userDetails!['name']),
                  _profileItem('Age', _userDetails!['age'].toString()),
                  _profileItem('Gender', _userDetails!['gender']),
                  _profileItem(
                      'Weight (kg)', _userDetails!['weightKg'].toString()),
                  _profileItem(
                    'Height',
                    '${_userDetails!['heightFeet']} ft ${_userDetails!['heightInches']} in',
                  ),
                ],
              ),
            ),
    );
  }

  Widget _profileItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        '$title: $value',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
