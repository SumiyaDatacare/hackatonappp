import 'package:flutter/material.dart';
import '../components/sidebar_screen.dart';

class PlanningPage extends StatelessWidget {
  final String? title;
  
  const PlanningPage({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String routeName = ModalRoute.of(context)?.settings.name ?? '';
    
    String pageTitle = 'PlanningPage Page';
    
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      drawer: SidebarDrawer(currentRoute: routeName),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.grey.shade700),
        title: Text(
          pageTitle,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 20),
            Text(
              pageTitle,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'palnning',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}