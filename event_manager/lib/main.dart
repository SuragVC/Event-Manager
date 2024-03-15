import 'package:calendar_view/calendar_view.dart';
import 'package:event_manager/ui/page/calendor_page.dart';
import 'package:flutter/material.dart';

EventController eventController = EventController();
void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: eventController,
      child: const MaterialApp(
        home: CalendorPage(),
      ),
    );
  }
}
