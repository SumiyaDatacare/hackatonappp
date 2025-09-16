import 'package:flutter/material.dart';

class SidebarDrawer extends StatefulWidget {
  final String currentRoute;

  const SidebarDrawer({Key? key, required this.currentRoute}) : super(key: key);

  @override
  State<SidebarDrawer> createState() => _SidebarDrawerState();
}

class _SidebarDrawerState extends State<SidebarDrawer> {
  // Track which main menu is expanded
  String? expandedMenu;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,
      child: Container(
        color: Colors.grey.shade50,
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.grey.shade600,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Батсуурь Сумъяа',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Reports - Simple menu
                  // _buildSimpleMenuItem(
                  //   icon: Icons.bar_chart_outlined,
                  //   title: 'Reports',
                  //   isSelected: widget.currentRoute == '/reports',
                  //   route: '/reports',
                  // ),
                  SizedBox(height: 4),
                  // Strategies with submenu - Blue
                  _buildMenuItemWithSubmenu(
                    icon: Icons.layers_outlined,
                    title: 'Байгууллага',
                    menuKey: 'strategies',
                    iconColor: Color(0xFF4285F4),
                    isSelected: widget.currentRoute.startsWith('/strategies'),
                    subMenuItems: [
                      SubMenuItem(
                        title: 'Компани',
                        route: '/strategies/ecommerce',
                      ),
                      SubMenuItem(title: 'БХҮГ', route: '/strategies/lead'),
                      SubMenuItem(
                        title: 'Оньс баг',
                        route: '/strategies/mobile',
                      ),
                      SubMenuItem(
                        title: 'Журмууд',
                        route: '/strategies/mobile',
                      ),
                    ],
                  ),

                  SizedBox(height: 4),

                  // Post boosting with submenu
                  _buildMenuItemWithSubmenu(
                    icon: Icons.account_circle,
                    title: 'Миний',
                    menuKey: 'boosting',
                    // iconColor: Colors.grey.shade600,
                    iconColor: Color(0xFF4285F4),
                    isSelected: widget.currentRoute.startsWith('/boosting'),
                    subMenuItems: [
                      SubMenuItem(
                        title: 'Ажлын байрны хөтөч',
                        route: '/boosting/facebook',
                      ),
                      SubMenuItem(
                        title: 'Хөнгөлөлтүүд',
                        route: '/boosting/instagram',
                      ),
                      SubMenuItem(
                        title: 'Сургалтууд',
                        route: '/boosting/instagram',
                      ),
                      SubMenuItem(
                        title: 'Тушаал, гэрээ',
                        route: '/boosting/instagram',
                      ),
                      SubMenuItem(title: 'Цалин', route: '/boosting/instagram'),
                      SubMenuItem(
                        title: 'Цаг бүртгэл',
                        route: '/boosting/instagram',
                      ),
                    ],
                  ),

                  SizedBox(height: 4),

                  // Assets - Simple menu
                  _buildMenuItemWithSubmenu(
                    icon: Icons.notification_add_outlined,
                    title: 'Мэдээллүүд',
                    menuKey: 'boostingss',
                    // iconColor: Colors.grey.shade600,
                    iconColor: Color(0xFF4285F4),
                    isSelected: widget.currentRoute.startsWith('/boostingss'),
                    subMenuItems: [
                      SubMenuItem(
                        title: 'Байгууллагын тэмдэглэлт өдрүүд',
                        route: '/assets/organization-days',
                      ),
                      SubMenuItem(
                        title: 'Утасны дугаар',
                        route: '/assets/phone-numbers',
                      ),
                      SubMenuItem(
                        title: 'Ажлын хуваарь',
                        route: '/assets/work-schedule',
                      ),
                      SubMenuItem(
                        title: 'Мэдэгдлүүд',
                        route: '/assets/notifications',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Simple menu item without submenu
  Widget _buildSimpleMenuItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required String route,
    Color? iconColor,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(icon, color: iconColor ?? Colors.grey.shade600, size: 20),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.black87 : Colors.grey.shade700,
          ),
        ),
        onTap: () {
          if (route != widget.currentRoute) {
            Navigator.pushReplacementNamed(context, route);
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  // Menu item with badge
  Widget _buildMenuItemWithBadge({
    required IconData icon,
    required String title,
    required String badge,
    required Color badgeColor,
    required bool isSelected,
    required String route,
    Color? iconColor,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(icon, color: iconColor ?? Colors.grey.shade600, size: 20),
        title: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? Colors.black87 : Colors.grey.shade700,
              ),
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          if (route != widget.currentRoute) {
            Navigator.pushReplacementNamed(context, route);
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  // Menu item with submenu
  Widget _buildMenuItemWithSubmenu({
    required IconData icon,
    required String title,
    required String menuKey,
    required List<SubMenuItem> subMenuItems,
    required bool isSelected,
    Color? iconColor,
  }) {
    bool isExpanded = expandedMenu == menuKey;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: (isSelected || isExpanded) ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        boxShadow: (isSelected || isExpanded)
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Icon(
              icon,
              color: iconColor ?? Colors.grey.shade600,
              size: 20,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: (isSelected || isExpanded)
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: (isSelected || isExpanded)
                    ? Colors.black87
                    : Colors.grey.shade700,
              ),
            ),
            trailing: AnimatedRotation(
              turns: isExpanded ? 0.5 : 0.0,
              duration: Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ),
            onTap: () {
              setState(() {
                expandedMenu = isExpanded ? null : menuKey;
              });
            },
          ),

          // Submenu items
          if (isExpanded)
            Container(
              padding: EdgeInsets.only(left: 52, bottom: 8),
              child: Column(
                children: subMenuItems.map((subItem) {
                  bool isSubSelected = widget.currentRoute == subItem.route;
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 1),
                    decoration: BoxDecoration(
                      color: isSubSelected
                          ? Colors.grey.shade100
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 2,
                      ),
                      title: Text(
                        subItem.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSubSelected
                              ? FontWeight.w500
                              : FontWeight.w400,
                          color: isSubSelected
                              ? Colors.black87
                              : Colors.grey.shade600,
                        ),
                      ),
                      onTap: () {
                        if (subItem.route != widget.currentRoute) {
                          Navigator.pushReplacementNamed(
                            context,
                            subItem.route,
                          );
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

// Helper class for submenu items
class SubMenuItem {
  final String title;
  final String route;
  final IconData? icon;
  final Color? color;

  SubMenuItem({
    required this.title,
    required this.route,
    this.icon,
    this.color,
  });
}
