import 'package:calendar_view/calendar_view.dart';
import 'package:event_manager/implementation/implementation.dart';
import 'package:event_manager/ui/widgets/dialogue_widget.dart';
import 'package:flutter/material.dart';

class CalendorPage extends StatefulWidget {
  const CalendorPage({super.key});

  @override
  State<CalendorPage> createState() => _CalendorPageState();
}

class _CalendorPageState extends State<CalendorPage> {
  GlobalKey<MonthViewState>? state;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<void>(
      future: Implementation.getEventsFromLocalStorage(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return MonthView(
            key: state,
            onEventTap: (event, date) => showDialog(
                builder: (context) => EventDialog(
                      date: date,
                      onSubmit: () => setState(() {}),
                      event: event,
                    ),
                context: context),
            minMonth: DateTime(1990),
            maxMonth: DateTime(2050),
            initialMonth: DateTime.now(),
            onCellTap: (events, date) => showDialog(
                builder: (context) => EventDialog(
                      date: date,
                      onSubmit: () => setState(() {}),
                    ),
                context: context),
            startDay: WeekDays.sunday,
          );
        }
      },
    ));
  }
}
