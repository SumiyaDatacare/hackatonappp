import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
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
  String selectedType = 'Meeting';
  
  // Events storage
  Map<DateTime, List<Event>> _events = {};
  
  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    final today = DateTime.now();
    final tomorrow = today.add(Duration(days: 1));
    final nextWeek = today.add(Duration(days: 7));
   _events = {
      DateTime(today.year, today.month, today.day): [
        Event('Багийн хурал', 'Хурал', '10:00'),
        Event('Төслийн үнэлгээ', 'Үнэлгээ', '14:00'),
        Event('Захирлын уулзалт', 'Хурал', '16:30'),
      ],
      DateTime(tomorrow.year, tomorrow.month, tomorrow.day): [
        Event('Ажилчдын сургалт', 'Сургалт', '09:00'),
        Event('Цайны цаг', 'Бусад', '15:00'),
      ],
      DateTime(nextWeek.year, nextWeek.month, nextWeek.day): [
        Event('Тайлан хүлээлгэх', 'Хугацаа', '17:00'),
        Event('Төрсөн өдөр - Батбаяр', 'Төрсөн өдөр', '12:00'),
      ],
    };
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
      body: SingleChildScrollView(
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
                    // Remove locale or use 'en_US' since we're manually handling Mongolian
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
                Text(
                  'Events on ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
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
          // _showQuickAddDialog(context);
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
                  'No events scheduled',
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
        elevation: 1,
        margin: EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
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
          subtitle: Text('${event.time} • ${event.type}'),
          trailing: IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
            onPressed: () => _deleteEvent(event),
          ),
        ),
      )).toList(),
    );
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
                items: ['Meeting', 'Birthday', 'Deadline', 'Review', 'Other']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
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
  
  void _addEvent() {
    if (titleController.text.isNotEmpty) {
      final date = _selectedDay ?? _focusedDay;
      final normalizedDate = DateTime(date.year, date.month, date.day);
      
      setState(() {
        if (!_events.containsKey(normalizedDate)) {
          _events[normalizedDate] = [];
        }
        _events[normalizedDate]!.add(
          Event(
            titleController.text,
            selectedType,
            selectedTime.format(context),
          ),
        );
        titleController.clear();
        descriptionController.clear();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Event added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
  
  void _deleteEvent(Event event) {
    setState(() {
      final date = _selectedDay ?? _focusedDay;
      final normalizedDate = DateTime(date.year, date.month, date.day);
      _events[normalizedDate]?.remove(event);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Event deleted'),
        backgroundColor: Colors.red,
      ),
    );
  }
  
  Color _getEventColor(String type) {
    switch (type) {
      case 'Meeting':
        return Color(0xFF24A1DE);
      case 'Birthday':
        return Colors.pink;
      case 'Deadline':
        return Colors.red;
      case 'Review':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
  
  IconData _getEventIcon(String type) {
    switch (type) {
      case 'Meeting':
        return Icons.people;
      case 'Birthday':
        return Icons.cake;
      case 'Deadline':
        return Icons.alarm;
      case 'Review':
        return Icons.rate_review;
      default:
        return Icons.event;
    }
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
  
  String _getMongolianWeekdayFull(int weekday) {
    const weekdays = [
      'Даваа гараг',
      'Мягмар гараг',
      'Лхагва гараг',
      'Пүрэв гараг',
      'Баасан гараг',
      'Бямба гараг',
      'Ням гараг',
    ];
    return weekdays[weekday - 1];
  }
  
  Color _getEventColor(String type) {
    switch (type) {
      case 'Хурал':
        return Color(0xFF24A1DE);
      case 'Төрсөн өдөр':
        return Colors.pink;
      case 'Хугацаа':
        return Colors.red;
      case 'Үнэлгээ':
        return Colors.orange;
      case 'Сургалт':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
  
  IconData _getEventIcon(String type) {
    switch (type) {
      case 'Хурал':
        return Icons.people;
      case 'Төрсөн өдөр':
        return Icons.cake;
      case 'Хугацаа':
        return Icons.alarm;
      case 'Үнэлгээ':
        return Icons.rate_review;
      case 'Сургалт':
        return Icons.school;
      default:
        return Icons.event;
    }
  }
// Event Model Class
class Event {
  final String title;
  final String type;
  final String time;
  
  Event(this.title, this.type, this.time);
  
  @override
  String toString() => title;
}