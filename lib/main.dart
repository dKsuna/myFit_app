import 'package:flutter/material.dart';
import 'package:myfit/screens/registration/details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/registration/name_screen.dart';
import 'screens/registration/age_screen.dart';
import 'screens/registration/weight_screen.dart';
import 'screens/registration/height_screen.dart';
import 'screens/registration/goal_screen.dart';
import 'screens/registration/experience_screen.dart';
import 'screens/registration/issues_screen.dart';
import 'screens/registration/days_screen.dart';
import 'screens/registration/equipment_screen.dart';
import 'screens/registration/summary.dart';
import 'screens/models/user_model.dart';
import 'package:myfit/screens/main_screen.dart';
import 'screens/registration/gender_screen.dart';
import 'package:myfit/database/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pfres = await SharedPreferences.getInstance();
  final bool isRegistered = pfres.getBool('isRegistered') ?? false;
  final String? userName = pfres.getString('userName');

  DBHelper db = DBHelper();
  await db.database;
  runApp(MyApp(
    isRegistered: isRegistered,
    userName: userName,
  ));
}

class MyApp extends StatelessWidget {
  final bool isRegistered;
  final String? userName;
  const MyApp({Key? key, required this.isRegistered, required this.userName});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'myFit',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: isRegistered ? MainScreen(userName: userName ?? '') : NameScreen(),
      routes: {
        '/age': (context) => AgeScreen(),
        '/gender': (context) => const GenderScreen(),
        '/weight': (context) => WeightScreen(),
        '/height': (context) => HeightScreen(),
        '/goal': (context) => GoalScreen(),
        '/experience': (context) => ExperienceScreen(),
        '/issues': (context) => IssuesScreen(),
        '/days': (context) => DaysScreen(),
        '/equipment': (context) => EquipmentScreen(),
        '/summary': (context) => SummaryScreen(),
        '/details': (context) {
          final user = ModalRoute.of(context)!.settings.arguments as User;
          return DetailsScreen(user: user);
        },
        '/main': (context) {
          final userName = ModalRoute.of(context)!.settings.arguments as String;
          return MainScreen(userName: userName);
        },
      },
    );
  }
}
