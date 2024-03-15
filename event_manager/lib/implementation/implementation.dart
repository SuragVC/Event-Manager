import 'dart:convert';

import 'package:calendar_view/calendar_view.dart';
import 'package:event_manager/implementation/schemas.dart';
import 'package:event_manager/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Implementation {
  static Future<void> setEventsToLocalStorage(
      List<CalendarEventData> eventsData) async {
    List<CalendarEventDataToLocal> events = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (CalendarEventData e in eventsData) {
      CalendarEventDataToLocal value = CalendarEventDataToLocal(
          startTime: e.startTime!,
          date: e.date,
          description: e.description!,
          endTime: e.endTime!,
          title: e.title);
      events.add(value);
    }
    String? eventsJsonFromLocal = prefs.getString('events');
    if (eventsJsonFromLocal != null) {
      List<dynamic> decoded = jsonDecode(eventsJsonFromLocal);
      List<CalendarEventDataToLocal> eventsFromLocal = decoded
          .map((data) => CalendarEventDataToLocal.fromJson(data))
          .toList();
      events.addAll(eventsFromLocal);
    }
    String eventsJson =
        jsonEncode(events.map((event) => event.toJson()).toList());
    await prefs.setString('events', eventsJson);
  }

  static Future<void> getEventsFromLocalStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? eventsJson = prefs.getString('events');
    List<CalendarEventData> dataList = [];
    if (eventsJson != null) {
      List<dynamic> decoded = jsonDecode(eventsJson);
      List<CalendarEventDataToLocal> eventsFromLocal = decoded
          .map((data) => CalendarEventDataToLocal.fromJson(data))
          .toList();
      for (CalendarEventDataToLocal e in eventsFromLocal) {
        dataList.add(CalendarEventData(
          date: e.startTime,
          title: e.title,
          description: e.description,
          startTime: e.startTime,
          endTime: e.endTime,
        ));
      }
      eventController.addAll(dataList);
    }
  }

  static Future<void> cancelEvent(CalendarEventData eventsData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? eventsJson = prefs.getString('events');

    if (eventsJson != null) {
      List<dynamic> decoded = jsonDecode(eventsJson);
      List<CalendarEventDataToLocal> eventsFromLocal = decoded
          .map((data) => CalendarEventDataToLocal.fromJson(data))
          .toList();

      // Filter out the event that matches the eventsData
      List<CalendarEventDataToLocal> updatedEvents =
          eventsFromLocal.where((e) => e.title != eventsData.title).toList();

      // Convert the updated list of events back to JSON
      String updatedEventsJson =
          jsonEncode(updatedEvents.map((event) => event.toJson()).toList());
      await prefs.setString('events', updatedEventsJson);
    }
  }

  static Future<void> cancelEventOfADate(CalendarEventData eventsData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? eventsJson = prefs.getString('events');

    if (eventsJson != null) {
      List<dynamic> decoded = jsonDecode(eventsJson);
      List<CalendarEventDataToLocal> eventsFromLocal = decoded
          .map((data) => CalendarEventDataToLocal.fromJson(data))
          .toList();

      CalendarEventDataToLocal removeData = eventsFromLocal.first;
      for (CalendarEventDataToLocal e in eventsFromLocal) {
        if (e.endTime == eventsData.endTime &&
            e.startTime == eventsData.startTime &&
            e.title == eventsData.title) {
          removeData = e;
        }
      }
      eventsFromLocal.remove(removeData);
      String updatedEventsJson =
          jsonEncode(eventsFromLocal.map((event) => event.toJson()).toList());
      await prefs.setString('events', updatedEventsJson);
    }
  }
}
