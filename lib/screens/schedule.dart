import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/sidebar_screen.dart';

class SchedulePage extends StatefulWidget {
  final String? title;
  
  const SchedulePage({Key? key, this.title}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeOfDay selectedTime = TimeOfDay.now();
  
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedType = 'meeting';
  List<String> selectedAttendees = [];
  List<Map<String, dynamic>> users = [];

  
  // Events storage
  Map<DateTime, List<Event>> _events = {};
  bool _isLoading = true;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchEvents();
    _fetchUsers();
  }
  
  Future<void> _fetchUsers() async {
  try {
    final response = await http.get(Uri.parse('http://10.150.10.17:5000/api/users'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        users = List<Map<String, dynamic>>.from(data['data']);
      });
    }
  } catch (e) {
    print("Error fetching users: $e");
  }
}

  // Fetch events from API
  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final response = await http.get(
        Uri.parse('http://10.150.10.17:5000/api/events'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          final List<dynamic> eventsData = responseData['data'];
          
          // Clear existing events
          _events.clear();
          
          // Process each event from API
          for (var eventData in eventsData) {
            final DateTime startDate = DateTime.parse(eventData['startDate']).toLocal();
            final DateTime normalizedDate = DateTime(startDate.year, startDate.month, startDate.day);
            
            final event = Event(
              id: eventData['_id'],
              title: eventData['title'],
              description: eventData['description'] ?? '',
              type: eventData['eventType'] ?? 'other',
              time: '${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')}',
              startDate: startDate,
              endDate: DateTime.parse(eventData['endDate']).toLocal(),
              location: eventData['location'] ?? '',
              organizer: eventData['organizer'] != null 
                ? Organizer.fromJson(eventData['organizer'])
                : null,
              attendees: (eventData['attendees'] as List?)
                ?.map((a) => Attendee.fromJson(a))
                .toList() ?? [],
              maxAttendees: eventData['maxAttendees'] ?? 0,
              isActive: eventData['isActive'] ?? true,
            );
            
            if (!_events.containsKey(normalizedDate)) {
              _events[normalizedDate] = [];
            }
            _events[normalizedDate]!.add(event);
          }
          
          setState(() {
            _isLoading = false;
          });
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading events: ${e.toString()}';
      });
      
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load events. Please try again.'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Retry',
            onPressed: _fetchEvents,
            textColor: Colors.white,
          ),
        ),
      );
    }
  }
  
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
  
  List<Event> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final String routeName = ModalRoute.of(context)?.settings.name ?? '';
    final primaryColor = Color(0xFF24A1DE);
    
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      drawer: SidebarDrawer(currentRoute: routeName),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.grey.shade700),
        title: Text(
          'Цагийн хуваарь',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: primaryColor),
            tooltip: 'Шинэчлэх',
            onPressed: _fetchEvents,
          ),
          IconButton(
            icon: Icon(Icons.today, color: primaryColor),
            tooltip: 'Өнөөдөр',
            onPressed: () {
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = DateTime.now();
              });
            },
          ),
        ],
      ),
      body: _isLoading
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: primaryColor),
                SizedBox(height: 16),
                Text(
                  'Loading events...',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calendar Card with table_calendar
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: TableCalendar<Event>(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        eventLoader: _getEventsForDay,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        calendarStyle: CalendarStyle(
                          outsideDaysVisible: false,
                          selectedDecoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          markerDecoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          markersMaxCount: 3,
                          markerSize: 6,
                          markerMargin: EdgeInsets.symmetric(horizontal: 0.5),
                          weekendTextStyle: TextStyle(color: Colors.red),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(fontSize: 13),
                          weekendStyle: TextStyle(fontSize: 13, color: Colors.red),
                        ),
                        headerStyle: HeaderStyle(
                          formatButtonVisible: true,
                          titleCentered: true,
                          formatButtonShowsNext: false,
                          formatButtonDecoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: primaryColor.withOpacity(0.3)),
                          ),
                          formatButtonTextStyle: TextStyle(
                            color: primaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          leftChevronIcon: Icon(Icons.chevron_left, color: primaryColor),
                          rightChevronIcon: Icon(Icons.chevron_right, color: primaryColor),
                          titleTextStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        calendarBuilders: CalendarBuilders(
                          dowBuilder: (context, day) {
                            final text = _getMongolianWeekday(day);
                            final isWeekend = day.weekday == DateTime.saturday || 
                                           day.weekday == DateTime.sunday;
                            
                            return Center(
                              child: Text(
                                text,
                                style: TextStyle(
                                  color: isWeekend ? Colors.red : Colors.grey.shade700,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                          headerTitleBuilder: (context, day) {
                            return Center(
                              child: Text(
                                '${_getMongolianMonth(day.month)} ${day.year}',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        onFormatChanged: (format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Сар',
                          CalendarFormat.twoWeeks: '2 долоо хоног',
                          CalendarFormat.week: 'Долоо хоног',
                        },
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 25),
                  
                  // Selected Day Events
                  if (_selectedDay != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Events on ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '${_getEventsForDay(_selectedDay!).length} events',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    _buildSelectedDayEvents(),
                  ],
                ],
              ),
            ),
          ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEventDialog(context);
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
  
  Widget _buildSelectedDayEvents() {
    final events = _getEventsForDay(_selectedDay!);
    
    if (events.isEmpty) {
      return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.event_available,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 10),
                Text(
                  'Төлөвлөгөө хоосон байна',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return Column(
      children: events.map((event) => Card(
        // elevation: 1,
        margin: EdgeInsets.only(bottom: 10),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(12),
        // ),
        child: ExpansionTile(
          leading: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: _getEventColor(event.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getEventIcon(event.type),
              color: _getEventColor(event.type),
            ),
          ),
          title: Text(
            event.title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${event.time} • ${_getEventTypeDisplay(event.type)}'),
              if (event.location.isNotEmpty)
                Text(
                  '${event.location}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
            ],
          ),
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (event.description.isNotEmpty) ...[
                    Text(
                      'Тайлбар:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      event.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    ),
                    SizedBox(height: 12),
                  ],
                  if (event.organizer != null) ...[
                    Text(
                      'Үүсгэсэн:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${event.organizer!.name} (${event.organizer!.department})',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    ),
                    SizedBox(height: 12),
                  ],
                  if (event.attendees.isNotEmpty) ...[
                    Text(
                      'Оролцогч (${event.attendees.length}/${event.maxAttendees}):',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: event.attendees.map((attendee) => Chip(
                        label: Text(
                          attendee.name,
                          style: TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      )).toList(),
                    ),
                    SizedBox(height: 12),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Хугацаа: ${_calculateDuration(event.startDate, event.endDate)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      if (event.isActive)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Идэвхтэй',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }
  
  String _calculateDuration(DateTime start, DateTime end) {
    final duration = end.difference(start);
    if (duration.inHours < 1) {
      return '${duration.inMinutes} минут';
    } else if (duration.inHours == 1) {
      return '1 hour';
    } else {
      return '${duration.inHours} цаг';
    }
  }
  
  void _showAddEventDialog(BuildContext context) {
    final primaryColor = const Color(0xFF24A1DE);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Төлөвлөгөө',
                    hintText: 'Нэр оруулна уу',
                    prefixIcon: Icon(Icons.event_note, color: primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Type
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: InputDecoration(
                    labelText: 'Төрөл',
                    prefixIcon: Icon(Icons.category, color: primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: ['meeting', 'workshop', 'conference', 'training', 'other']
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(_getEventTypeDisplay(type)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                    });
                  },
                ),
                const SizedBox(height: 12),

                // Date & Time
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Огноо',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            '${_selectedDay?.day ?? _focusedDay.day}/${_selectedDay?.month ?? _focusedDay.month}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Цаг',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            selectedTime.format(context),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
  isExpanded: true,
  decoration: InputDecoration(
    labelText: 'Оролцогчид',
    prefixIcon: Icon(Icons.people, color: primaryColor),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  items: users.map((user) {
    return DropdownMenuItem<String>(
      value: user['_id'],
      child: Text(user['name']),
    );
  }).toList(),
  onChanged: (value) {
    if (value != null && !selectedAttendees.contains(value)) {
      setState(() {
        selectedAttendees.add(value);
      });
    }
  },
),
const SizedBox(height: 8),

// Show selected attendees as chips
Wrap(
  spacing: 6,
  children: selectedAttendees.map((id) {
    final user = users.firstWhere((u) => u['_id'] == id);
    return Chip(
      label: Text(user['name']),
      onDeleted: () {
        setState(() {
          selectedAttendees.remove(id);
        });
      },
    );
  }).toList(),
),


                // Description
                TextFormField(
                  controller: descriptionController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Тайлбар',
                    hintText: 'Тайлбар оруулна уу',
                    prefixIcon: Icon(Icons.description, color: primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Button
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      _addEvent();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 1,
                    ),
                    child: const Text(
                      'Нэмэх',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDay ?? _focusedDay,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF24A1DE),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDay = picked;
        _focusedDay = picked;
      });
    }
  }
  
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF24A1DE),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }
  
  Future<void> _addEvent() async {
  if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill in all required fields'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  final date = _selectedDay ?? _focusedDay;
  final startDateTime = DateTime(
    date.year,
    date.month,
    date.day,
    selectedTime.hour,
    selectedTime.minute,
  );

  final endDateTime = startDateTime.add(const Duration(hours: 1));

  try {
    final response = await http.post(
      Uri.parse('http://10.150.10.17:5000/api/events'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "title": titleController.text,
        "description": descriptionController.text,
        "eventType": selectedType,
        "startDate": startDateTime.toUtc().toIso8601String(),
        "endDate": endDateTime.toUtc().toIso8601String(),
        "location": "7 давхар", // replace with real input later
        "organizer": "66f3b8b8f8d0c23ad0a12345", // replace with actual logged-in user id
        "attendees": selectedAttendees,
        "maxAttendees": 10,
        "isActive": true,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      // Successfully added
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event added successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh event list from API
      _fetchEvents();

      // Clear form
      titleController.clear();
      descriptionController.clear();
    } else {
      throw Exception('Failed to add event: ${response.body}');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error adding event: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  
  Color _getEventColor(String type) {
    switch (type.toLowerCase()) {
      case 'meeting':
        return Color(0xFF24A1DE);
      case 'workshop':
        return Colors.purple;
      case 'conference':
        return Colors.orange;
      case 'training':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
  
  IconData _getEventIcon(String type) {
    switch (type.toLowerCase()) {
      case 'meeting':
        return Icons.people;
      case 'workshop':
        return Icons.build;
      case 'conference':
        return Icons.business;
      case 'training':
        return Icons.school;
      default:
        return Icons.event;
    }
  }
  
  String _getEventTypeDisplay(String type) {
    switch (type.toLowerCase()) {
      case 'meeting':
        return 'Хурал';
      case 'workshop':
        return 'Семинар';
      case 'conference':
        return 'Хурал';
      case 'training':
        return 'Сургалт';
      default:
        return 'Бусад';
    }
  }
  
  String _getMongolianMonth(int month) {
    const months = [
      'Нэгдүгээр сар',
      'Хоёрдугаар сар',
      'Гуравдугаар сар',
      'Дөрөвдүгээр сар',
      'Тавдугаар сар',
      'Зургадугаар сар',
      'Долдугаар сар',
      'Наймдугаар сар',
      'Есдүгээр сар',
      'Аравдугаар сар',
      'Арван нэгдүгээр сар',
      'Арван хоёрдугаар сар',
    ];
    return months[month - 1];
  }
  
  String _getMongolianWeekday(DateTime day) {
    const weekdays = ['Да', 'Мя', 'Лх', 'Пү', 'Ба', 'Бя', 'Ня'];
    return weekdays[day.weekday - 1];
  }
}

// Event Model Class
class Event {
  final String id;
  final String title;
  final String description;
  final String type;
  final String time;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final Organizer? organizer;
  final List<Attendee> attendees;
  final int maxAttendees;
  final bool isActive;
  
  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.time,
    required this.startDate,
    required this.endDate,
    required this.location,
    this.organizer,
    required this.attendees,
    required this.maxAttendees,
    required this.isActive,
  });
  
  @override
  String toString() => title;
}

// Organizer Model
class Organizer {
  final String id;
  final String name;
  final String email;
  final String department;
  
  Organizer({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
  });
  
  factory Organizer.fromJson(Map<String, dynamic> json) {
    return Organizer(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      department: json['department'],
    );
  }
}

// Attendee Model
class Attendee {
  final String id;
  final String name;
  final String email;
  final String department;
  
  Attendee({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
  });
  
  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      department: json['department'],
    );
  }
}