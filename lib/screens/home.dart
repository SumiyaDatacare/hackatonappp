import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFF5F6FA),
      drawer: _buildDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Profile
                _buildHeader(),
                SizedBox(height: 30),
                
                // Today's Overview Section
                Text(
                  "Today's Overview",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                
                // Overview Cards Grid
                _buildOverviewCards(),
                SizedBox(height: 30),
                
                // Reminders Section
                _buildRemindersSection(),
                SizedBox(height: 30),
                
                // Employees Section
                _buildEmployeesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Drawer Header with User Profile
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 50, bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.deepPurple.shade400,
                    Colors.deepPurple.shade700,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(45),
                      child: Icon(
                        Icons.person,
                        color: Colors.grey.shade400,
                        size: 50,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Mason Lee',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'HR Manager',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'mason.lee@company.com',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            
            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 10),
                children: [
                  _buildDrawerItem(
                    icon: Icons.dashboard_outlined,
                    title: 'Dashboard',
                    onTap: () {
                      Navigator.pop(context);
                    },
                    isSelected: true,
                  ),
                  _buildDrawerItem(
                    icon: Icons.people_outline,
                    title: 'Employees',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to employees page
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.calendar_today_outlined,
                    title: 'Calendar',
                    badge: '3',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to calendar page
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.assessment_outlined,
                    title: 'Reports',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to reports page
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.work_outline,
                    title: 'Recruitment',
                    badge: '5',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to recruitment page
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.attach_money_outlined,
                    title: 'Payroll',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to payroll page
                    },
                  ),
                  Divider(height: 30, thickness: 1, indent: 20, endIndent: 20),
                  _buildDrawerItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to settings page
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to help page
                    },
                  ),
                ],
              ),
            ),
            
            // Logout Button
            Container(
              padding: EdgeInsets.all(20),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? badge,
    bool isSelected = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.deepPurple.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.deepPurple : Colors.grey.shade700,
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.deepPurple : Colors.grey.shade800,
          ),
        ),
        trailing: badge != null
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Icon(
                Icons.person,
                color: Colors.grey.shade600,
                size: 30,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mason Lee',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'HR manager',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.notifications_outlined),
              onPressed: () {},
              color: Colors.black87,
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.3,
      children: [
        _buildOverviewCard(
          title: 'Active\nemployee',
          count: '85',
          percentage: '+15%',
          color: Color(0xFFF0F1F5),
          textColor: Colors.black87,
          icon: Icons.people_outline,
        ),
        _buildOverviewCard(
          title: 'Total\nemployee',
          count: '150',
          percentage: '+15%',
          color: Color(0xFFFF6B35),
          textColor: Colors.white,
          icon: Icons.groups_outlined,
        ),
        _buildOverviewCard(
          title: 'New hires',
          count: '8',
          percentage: '+25%',
          color: Color(0xFF4ECDC4),
          textColor: Colors.white,
          icon: Icons.person_add_outlined,
        ),
        _buildOverviewCard(
          title: 'Reviewed',
          count: '4',
          percentage: '+20%',
          color: Color(0xFFFFE5E5),
          textColor: Color(0xFFFF6B6B),
          icon: Icons.rate_review_outlined,
        ),
      ],
    );
  }

  Widget _buildOverviewCard({
    required String title,
    required String count,
    required String percentage,
    required Color color,
    required Color textColor,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor.withOpacity(0.8),
                  height: 1.3,
                ),
              ),
              Icon(
                icon,
                color: textColor.withOpacity(0.6),
                size: 24,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: textColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  percentage,
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reminders',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.grey),
              onPressed: () {},
            ),
          ],
        ),
        SizedBox(height: 10),
        _buildReminderItem(
          title: 'Brand Meeting',
          subtitle: 'Today - 11:45 am',
          icon: Icons.videocam_outlined,
          tagText: 'New',
          tagColor: Color(0xFF4ECDC4),
          iconColor: Colors.blue,
        ),
        _buildReminderItem(
          title: 'Evelyn Kim',
          subtitle: 'Tomorrow - 2:30 pm',
          icon: Icons.cake_outlined,
          tagText: 'New',
          tagColor: Color(0xFF4ECDC4),
          iconColor: Colors.pink,
        ),
        _buildReminderItem(
          title: 'Contract Revision',
          subtitle: 'Next week - 9:00 am',
          icon: Icons.calendar_today_outlined,
          tagText: null,
          tagColor: Colors.transparent,
          iconColor: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildReminderItem({
    required String title,
    required String subtitle,
    required IconData icon,
    String? tagText,
    required Color tagColor,
    required Color iconColor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (tagText != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: tagColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tagText,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          SizedBox(width: 8),
          Text(
            title == 'Brand Meeting' ? 'Meeting' : 
            title == 'Evelyn Kim' ? 'Birthday' : 'Deadline',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Employees',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.grey),
              onPressed: () {},
            ),
          ],
        ),
        SizedBox(height: 10),
        _buildEmployeeItem(
          name: 'Anil Tanronto',
          role: 'Product Designer',
          department: 'Design Department',
          avatarColor: Colors.blue,
        ),
        _buildEmployeeItem(
          name: 'Jacob Thomas',
          role: 'Back-end Developer',
          department: 'Development Department',
          avatarColor: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildEmployeeItem({
    required String name,
    required String role,
    required String department,
    required Color avatarColor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: avatarColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name.split(' ').map((e) => e[0]).take(2).join(),
                style: TextStyle(
                  color: avatarColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      ' • ',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    Text(
                      department,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}