import 'package:flutter/material.dart';
import 'package:myfit/screens/registration/details_screen.dart';
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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'myFit',
      initialRoute: '/',
      routes: {
        '/': (context) => NameScreen(),
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
        '/main': (context) => const MainScreen(),
      },
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
    );
  }
}
