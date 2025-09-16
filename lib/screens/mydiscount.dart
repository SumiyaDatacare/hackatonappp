import 'package:flutter/material.dart';

void main() {
  runApp(Mydiscount());
}

class Mydiscount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mydiscount App',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      home: MydiscountPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MydiscountPage extends StatelessWidget {
  final String? title;

  const MydiscountPage({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String routeName = ModalRoute.of(context)?.settings.name ?? '';

    String pageTitle = 'Mydiscount';

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
      body: TaskListScreen(),
    );
  }
}

class SidebarDrawer extends StatelessWidget {
  final String currentRoute;

  const SidebarDrawer({Key? key, required this.currentRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.home,
            title: 'Home',
            route: '/home',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.discount,
            title: 'Mydiscount',
            route: '/mydiscount',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.person,
            title: 'Newbie',
            route: '/newbie',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            title: 'Settings',
            route: '/settings',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    bool isSelected = currentRoute == route;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.blue : Colors.grey.shade600,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black87,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context);
        // Add navigation logic here
      },
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<TaskItem> tasks = [
    TaskItem(
      time: "13:00",
      title: "Цалинтай чөлөө",
      isCompleted: true,
      subtasks: [
        SubTask("Ажилтны өөрийн төрсөн өдөрт – Ажлын 1 өдөр ", true),
        SubTask(
          "Хүүхдийн төрсөн өдөрт – тухайн ажлын өдрийн 2 цагийн чөлөө",
          true,
        ),
        SubTask("Эцэг эхийн хуралд- 2 цагийн цалинтай чөлөө", true),
      ],
    ),
    TaskItem(
      time: "14:30",
      title: "Үүрэн телефоны хөнгөлөлт",
      description:
          "Гэрээт үүрэн телефоны дараа төлбөрт үйлчилгээнд хамрагдах ажилтанд компаниас баталгаа гаргаж өгснөөр барьцааны мөнгө төлөхгүй, бүртгэлийн хураамжаас чөлөөлөгдөнө. Нэг ажилтанд нэг дугаар гэсэн зарчим үйлчилнэ.",
      isCompleted: true,
      subtasks: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return TaskCard(
              task: tasks[index],
              onTaskToggle: (value) {
                setState(() {
                  tasks[index].isCompleted = value;
                });
              },
              onSubTaskToggle: (subTaskIndex, value) {
                setState(() {
                  tasks[index].subtasks[subTaskIndex].isCompleted = value;
                });
              },
            );
          },
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final TaskItem task;
  final Function(bool) onTaskToggle;
  final Function(int, bool) onSubTaskToggle;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onTaskToggle,
    required this.onSubTaskToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main task
          Row(
            children: [
              GestureDetector(
                onTap: () => onTaskToggle(!task.isCompleted),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: task.isCompleted
                          ? Colors.green
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                    color: task.isCompleted ? Colors.green : Colors.transparent,
                  ),
                  child: task.isCompleted
                      ? Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          // Description (if exists)
          if (task.description != null && task.description!.isNotEmpty) ...[
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(left: 32),
              child: Text(
                task.description!,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
            ),
          ],
          SizedBox(height: 12),
          // Subtasks
          ...task.subtasks.asMap().entries.map((entry) {
            int index = entry.key;
            SubTask subtask = entry.value;
            return Padding(
              padding: EdgeInsets.only(left: 32, bottom: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => onSubTaskToggle(index, !subtask.isCompleted),
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: subtask.isCompleted
                              ? Colors.green
                              : Colors.grey.shade400,
                          width: 1.5,
                        ),
                        color: subtask.isCompleted
                            ? Colors.green
                            : Colors.transparent,
                      ),
                      child: subtask.isCompleted
                          ? Icon(Icons.check, size: 10, color: Colors.white)
                          : null,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      subtask.title,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class TaskItem {
  final String time;
  final String title;
  final String? description;
  bool isCompleted;
  final List<SubTask> subtasks;

  TaskItem({
    required this.time,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.subtasks,
  });

  double get completionPercentage {
    if (subtasks.isEmpty) return isCompleted ? 1.0 : 0.0;
    int completedCount = subtasks.where((s) => s.isCompleted).length;
    return completedCount / subtasks.length;
  }
}

class SubTask {
  final String title;
  bool isCompleted;

  SubTask(this.title, this.isCompleted);
}
