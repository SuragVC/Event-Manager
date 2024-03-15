import 'package:calendar_view/calendar_view.dart';
import 'package:event_manager/implementation/implementation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventDialog extends StatefulWidget {
  const EventDialog(
      {super.key, required this.date, required this.onSubmit, this.event});
  final DateTime date;
  final Function() onSubmit;
  final CalendarEventData? event;
  @override
  State createState() => _EventDialogState();
}

class _EventDialogState extends State<EventDialog> {
  String _repeatValue = 'Daily';
  TextEditingController tittleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController repeatController = TextEditingController();
  late bool isReadOnly;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    isReadOnly = widget.event != null;
    if (widget.event != null) {
      tittleController.text = widget.event!.title;
      timeController.text = widget.event!.description!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Event Details')),
      content: isLoading
          ? const Center(
              child: SizedBox(
                  width: 100, height: 100, child: CircularProgressIndicator()),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: tittleController,
                    decoration: InputDecoration(
                      labelText: 'Event Tittle',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color(0xff052872),
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff052872))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff052872))),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        timeController.text = pickedTime.format(context);
                      }
                    },
                    child: IgnorePointer(
                      child: TextField(
                        controller: timeController,
                        readOnly: true, // Make it read-only
                        decoration: InputDecoration(
                          labelText: 'Time',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Color(0xff052872),
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff052872))),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff052872))),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          hintStyle: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                widget.event == null
                    ? DropdownButtonFormField(
                        value: _repeatValue,
                        onChanged: (newValue) {
                          setState(() {
                            _repeatValue = newValue.toString();
                          });
                        },
                        items: ['Daily', 'Weekly', 'Monthly']
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ))
                            .toList(),
                        decoration: InputDecoration(
                          labelText: 'Repeat',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                                width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 2.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.blue),
                        iconEnabledColor: Colors.blue,
                        style: const TextStyle(color: Colors.black),
                      )
                    : const SizedBox(),
              ],
            ),
      actions: widget.event == null
          ? <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (tittleController.text.isEmpty ||
                      timeController.text.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Please fill all the data",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    return;
                  }

                  setState(() {
                    isLoading = true;
                  });
                  if (_repeatValue == 'Daily') {
                    List<CalendarEventData> calendorEventList = [];
                    DateTime startTime = DateTime(widget.date.year,
                        widget.date.month, widget.date.day, 18, 30);
                    DateTime endTime = DateTime(2030);
                    while (startTime.isBefore(endTime)) {
                      CalendarEventData event = CalendarEventData(
                        date: startTime,
                        title: tittleController.text,
                        description: timeController.text,
                        startTime: startTime,
                        endTime: endTime,
                      );
                      calendorEventList.add(event);
                      startTime = startTime.add(const Duration(days: 1));
                    }
                    CalendarControllerProvider.of(context)
                        .controller
                        .addAll(calendorEventList);

                    await Implementation.setEventsToLocalStorage(
                        calendorEventList);
                  } else if (_repeatValue == 'Weekly') {
                    List<CalendarEventData> calendorEventList = [];
                    DateTime startTime = DateTime(widget.date.year,
                        widget.date.month, widget.date.day, 18, 30);
                    DateTime endTime = DateTime(2030);
                    while (startTime.isBefore(endTime)) {
                      CalendarEventData event = CalendarEventData(
                        date: startTime,
                        title: tittleController.text,
                        description: timeController.text,
                        startTime: startTime,
                        endTime: endTime,
                      );
                      calendorEventList.add(event);
                      startTime = startTime.add(const Duration(days: 7));
                    }
                    CalendarControllerProvider.of(context)
                        .controller
                        .addAll(calendorEventList);

                    await Implementation.setEventsToLocalStorage(
                        calendorEventList);
                  } else if (_repeatValue == 'Monthly') {
                    List<CalendarEventData> calendorEventList = [];

                    DateTime startTime = DateTime(widget.date.year,
                        widget.date.month, widget.date.day, 18, 30);
                    DateTime endTime = DateTime(2030);
                    while (startTime.isBefore(endTime)) {
                      CalendarEventData event = CalendarEventData(
                        date: startTime,
                        title: tittleController.text,
                        description: timeController.text,
                        startTime: startTime,
                        endTime: endTime,
                      );

                      startTime = DateTime(startTime.year, startTime.month + 1,
                          startTime.day, 18, 30);
                      calendorEventList.add(event);
                    }
                    CalendarControllerProvider.of(context)
                        .controller
                        .addAll(calendorEventList);
                    await Implementation.setEventsToLocalStorage(
                        calendorEventList);
                  }
                  setState(() {
                    isLoading = false;
                  });
                  widget.onSubmit();
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ]
          : [
              ElevatedButton(
                onPressed: () async {
                  List<CalendarEventData> listOfEvents =
                      CalendarControllerProvider.of(context)
                          .controller
                          .allEvents;

                  List<CalendarEventData> filteredEvents = [];

                  for (CalendarEventData e in listOfEvents) {
                    if (e.title == widget.event!.title) {
                      filteredEvents.add(e);
                    }
                  }

                  CalendarControllerProvider.of(context)
                      .controller
                      .removeAll(filteredEvents);

                  await Implementation.cancelEvent(widget.event!);
                  widget.onSubmit();
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 240, 93, 93)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                child: const Text('Cancel All'),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  CalendarControllerProvider.of(context)
                      .controller
                      .remove(widget.event!);
                  await Implementation.cancelEventOfADate(widget.event!);
                  widget.onSubmit();
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 240, 93, 93)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                child: const Text('Cancel'),
              )
            ],
    );
  }
}
