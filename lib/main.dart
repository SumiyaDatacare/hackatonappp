import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/schedule.dart';
import 'screens/mydiscount.dart';
import 'screens/planning.dart';
import 'screens/daily.dart';
import 'screens/newbie.dart';
import 'screens/users.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/schedule': (context) => SchedulePage(),
        '/mydiscount': (context) => Mydiscount(),
        '/planning': (context) => PlanningPage(),
        '/daily': (context) => DailyPage(),
        '/newbie': (context) => NewbiePage(),
        '/users': (context) => UsersPage(),
      },
    );
  }
}
