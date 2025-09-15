import 'package:flutter/material.dart';

class SidebarDrawer extends StatelessWidget {
  final String currentRoute;
  
  const SidebarDrawer({
    Key? key,
    required this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 340,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 60, 20, 30),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFE4E6),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Icon(
                        Icons.person,
                        color: Color(0xFFEC4899),
                        size: 32,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Хөгжүүлэгч',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Батсуурь Сумъяа',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Main Section Label
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Үндсэн ажилтан',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            
            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuItem(
                    context: context,
                    icon: Icons.home_outlined,
                    title: 'Нүүр хуудас',
                    route: '/home',
                    isSelected: currentRoute == '/home',
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.calendar_month_outlined,
                    title: 'Цагийн хуваарь',
                    route: '/schedule',
                    isSelected: currentRoute == '/schedule',
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.article_outlined,
                    title: 'Цаг төлөвлөгөө оруулах',
                    route: '/planning',
                    isSelected: currentRoute == '/planning',
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.today_rounded,
                    title: 'Өнөөдрийн ажлууд',
                    route: '/daily',
                    isSelected: currentRoute == '/daily',
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.new_label_outlined,
                    title: 'Шинэ ажилтаны хөтөч',
                    route: '/newbie',
                    isSelected: currentRoute == '/newbie',
                  ),
                ],
              ),
            ),
            
            Divider(height: 1, color: Colors.grey.shade300),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.grey.shade700,
                size: 22,
              ),
              title: Text(
                'Гарах',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    bool isSelected = false,
    bool hasDropdown = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFFF3F4F6) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          color: isSelected ? Colors.black87 : Colors.grey.shade700,
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.black87 : Colors.grey.shade700,
          ),
        ),
        trailing: hasDropdown
            ? Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey.shade600,
                size: 20,
              )
            : null,
        onTap: () {
          if (route != currentRoute) {
            Navigator.pushReplacementNamed(context, route);
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}