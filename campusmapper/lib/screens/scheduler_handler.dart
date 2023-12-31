/*
Author: Jaelen Wright - 100790481
This page manages the course and event schedule page, which displays the user's courses and events
*/
import 'dart:async';

import 'package:campusmapper/screens/course_search_page.dart';
import 'package:campusmapper/screens/schedule_page.dart';
import 'package:campusmapper/screens/student_login.dart';
import 'package:flutter/material.dart';
import 'package:campusmapper/models/sqflite/logged_in_model.dart';
import 'package:campusmapper/models/sqflite/scheduler_database_helper.dart';
import 'package:campusmapper/utilities/classes/user.dart';
import 'package:campusmapper/screens/event_add_page.dart';
import 'package:campusmapper/screens/event_edit_page.dart';
import 'package:campusmapper/utilities/classes/events.dart';
import 'package:campusmapper/utilities/classes/courses.dart';
import 'package:intl/intl.dart';
import 'package:campusmapper/utilities/date_conversions.dart';
import 'package:campusmapper/screens/calendar_view.dart';
import 'package:campusmapper/models/firestore/firebase_model.dart';

//model for course database
final _courses = CoursesModel();

//model for events database
final _events = EventsModel();

//class for holding course tile data

class SchedulerHandlerPage extends StatefulWidget {
  const SchedulerHandlerPage({super.key});

  @override
  State<SchedulerHandlerPage> createState() => _SchedulerHandlerPageState();
}

class _SchedulerHandlerPageState extends State<SchedulerHandlerPage> {
  //Only for use with the Schedule page
  //list of courses to be populated by database
  List<Course> coursesList = [];
  // list of events to be populated by database
  List<Event> eventsList = [];
  //flag for switch between course and event data
  bool isSwitched = false;

  final FirebaseModel _database = FirebaseModel();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (await loggedIn()) {
        loadEventsData();
        loadCoursesData();
      } else {
        sendToLogin();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  //check if user is logged in,
  Future<bool> loggedIn() async {
    List<User> user = await UserModel().getUser();
    if (user.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //send user to the log in page if they are not logged in
  void sendToLogin() {
    showDialog(
      //We want the users to log in
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User is not logged in'),
          content: const Text('Press "Ok" to be sent to log in page '),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StudentLoginPage(
                            forced: true,
                          )),
                );
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  //inform user that they aren't registered for any courses
  void noCourses() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No courses selected'),
          content:
              const Text('You are currently not registered for any courses '),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Ok'),
            ),
            TextButton(
              onPressed: () {
                /*
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CourseSearchPage()),
                ).then((value) => null);

                 */

                Navigator.of(context)
                    .push(MaterialPageRoute(
                  builder: (context) => const CourseSearchPage(),
                ))
                    .then((value) {
                  // you can do what you need here
                  Navigator.of(context).pop();
                  loadCoursesData();
                  setState(() {
                  });
                });
              },
              child: const Text('Select Courses'),
            ),
          ],
        );
      },
    );
  }

  //get all the course data from databases
  void loadCoursesData() async {
    List results = [];

    //check local first to see if any data is saved
    results = await _courses.getAllCoursesLocal();
    if (results.isNotEmpty) {
      for (int i = 0; i < results.length; i++) {
        coursesList.add(Course(
          id: results[i].id,
          weekday: results[i].weekday,
          courseName: results[i].courseName,
          profName: results[i].profName,
          roomNum: results[i].roomNum,
          endTime: results[i].endTime,
          startTime: results[i].startTime,
        ));
      }
    } else {
      //check global database if no data is saved
      results = await _database.getAllCoursesCloud();
      if (results.isNotEmpty) {
        for (int i = 0; i < results.length; i++) {
          coursesList.add(Course(
            id: results[i].id,
            weekday: results[i].weekday,
            courseName: results[i].courseName,
            profName: results[i].profName,
            roomNum: results[i].roomNum,
            endTime: results[i].endTime,
            startTime: results[i].startTime,
          ));
          //add to local database for next load
          await _courses.insertLocal(Course(
            id: results[i].id,
            weekday: results[i].weekday,
            courseName: results[i].courseName,
            profName: results[i].profName,
            roomNum: results[i].roomNum,
            endTime: results[i].endTime,
            startTime: results[i].startTime,
          ));
        }
      } else {
        //popup that tells the user they do not have any courses registered
        noCourses();
      }
    }
    setState(() {}); // rebuild when page is loaded
  }

  //get all the event data from databases
  void loadEventsData() async {
    List results = [];

    //check local first to see if any data is saved
    results = await _events.getAllEventsLocal();
    if (results.isNotEmpty) {
      for (int i = 0; i < results.length; i++) {
        eventsList.add(Event(
            id: results[i].id,
            eventName: results[i].eventName,
            location: results[i].location,
            weekday: results[i].weekday,
            time: results[i].time,
            date: results[i].date));
      }
    } else {
      //check global database if no data is saved
      results = await _database.getAllEventsCloud();
      if (results.isNotEmpty) {
        for (int i = 0; i < results.length; i++) {
          eventsList.add(Event(
              id: results[i].id,
              eventName: results[i].eventName,
              location: results[i].location,
              weekday: results[i].weekday,
              time: results[i].time,
              date: results[i].date));

          //add to local database for next save
          _events.insertEventLocal(Event(
              id: results[i].id,
              eventName: results[i].eventName,
              location: results[i].location,
              weekday: results[i].weekday,
              time: results[i].time,
              date: results[i].date));
        }
      }
    }
    setState(() {}); // rebuilds everytime page is loaded
  }

  //add an event to the database and eventTile list
  Future<void> _addEvent() async {
    //Navigate to EventAddPage to add event
    var newEventData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EventAddPage(), // Navigate to EventAddPage
      ),
    );

    //check if user made a new event
    if (newEventData != null) {
      final String newEventName = newEventData['eventName'];
      final String newLocation = newEventData['location'];
      final String newWeekday = newEventData['weekday'];
      final String newTime = newEventData['time'];
      final DateTime newDate = newEventData['date'];

      // Add the new data to the cloud + get ref id for local database
      String newId = await _database.insertEventCloud(
          newWeekday, newEventName, newLocation, newTime, newDate);
      //add to eventTile list
      setState(() {
        eventsList.add(Event(
            id: newId,
            eventName: newEventName,
            location: newLocation,
            weekday: newWeekday,
            time: newTime,
            date: newDate));
      });

      // Insert the new data into the local database
      _events.insertEventLocal(Event(
          id: newId,
          eventName: newEventName,
          location: newLocation,
          weekday: newWeekday,
          time: newTime,
          date: newDate));
    }
  }

  //popup for user to confirm if they want to delete their event
  Future<bool> _confirmDeleteEvent(Event eventToDelete) async{
    Completer <bool> completer = Completer<bool>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Do you want to delete ${eventToDelete.eventName}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteEvent(eventToDelete.id!); // Perform delete operation
                Navigator.of(context).pop(true); // Close the dialog
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    ).then((value){
      completer.complete(value ?? false);
    });
    return completer.future;
  }

  //delete selected event from databases and eventTile list
  Future<void> _deleteEvent(String id) async {
    setState(() {
      eventsList.removeWhere((event) => event.id == id);
    });
    //delete from local database
    await _events.deleteEventLocal(id);
    //delete from cloud database
    await _database.deleteEventCloud(id);
  }

  //go to eventEditPage and update database
  void _editEvent(Event event) async {
    //get current event info
    final initialEventName = event.eventName;
    final initialLocation = event.location;
    final initialWeekday = event.weekday;
    final initialTime = event.time;
    final initialDate = event.date;

    var updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventEditPage(
          eventName: initialEventName,
          location: initialLocation,
          weekday: initialWeekday,
          time: initialTime,
          date: initialDate,
        ),
      ),
    );

    //check for if data was even changed
    if (updatedData != null) {
      final updatedEvent = Event(
        id: event.id,
        eventName: updatedData['eventName'],
        location: updatedData['location'],
        weekday: updatedData['weekday'],
        time: updatedData['time'],
        date: updatedData['date'],
      );

      setState(() {
        //get the index of where to change
        final index =
            eventsList.indexWhere((eventTile) => eventTile.id == event.id);
        //update event in eventTile list
        if (index != -1) {
          eventsList[index] = Event(
            id: updatedEvent.id,
            eventName: updatedEvent.eventName,
            location: updatedEvent.location,
            weekday: updatedEvent.weekday,
            time: updatedEvent.time,
            date: updatedEvent.date,
          );
        }
      });

      // Update the event in the local database
      await _events.updateEventLocal(updatedEvent);
      // Update the event in the cloud database
      await _database.updateEventCloud(updatedEvent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          iconSize: 25,
        ),
        title: const Row(children: [
          Padding(
              padding: EdgeInsetsDirectional.only(start: 10),
              child: Text('Scheduler'))
        ]),
        actions: <Widget>[
          isSwitched
              ? IconButton(
                  onPressed: () {
                    _addEvent();
                  },
                  icon: const Icon(Icons.add))
              : Container(),
          isSwitched
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CalendarPage(
                            events: eventsList, displayEvents: isSwitched),
                      ),
                    );
                  },
                  icon: const Icon(Icons.calendar_month))
              : Container(),
          !isSwitched
              ? IconButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SchedulePage(courses: coursesList),
                      ),
                    );
                    setState(() {});
                  },
                  icon: const Icon(Icons.list_alt))
              : Container(),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Show Courses',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
              const Text(
                'Show Planned Events',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Display the first row with Monday and Tuesday
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < 2; i++)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(16),
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          getWeekday(i),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: selectWidgets(getWeekday(i), isSwitched),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // Display the second row with Wednesday and Thursday
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 2; i < 4; i++)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(16),
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          getWeekday(i),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: selectWidgets(getWeekday(i), isSwitched),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // Display the third row with Friday centered horizontally
          Center(
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(16),
              height: 200,
              width: 210,
              color: Colors.grey[300],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    getWeekday(4),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: selectWidgets(getWeekday(4), isSwitched),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //checks whether to show user's course or event data
  List<Widget> selectWidgets(String weekday, bool isEvents) {
    if (isEvents) {
      return getEventWidgets(weekday);
    } else {
      return getCourseWidgets(weekday);
    }
  }

  //used chatgpt for most of this function
  List<Widget> getCourseWidgets(String weekday) {
    List<Widget> widgets = [];

    List<Course> filteredCourses =
        coursesList.where((course) => course.weekday == weekday).toList();

    for (int i = 0; i < filteredCourses.length; i++) {
      widgets.addAll([
        Text(
          filteredCourses[i].courseName!,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          filteredCourses[i].profName!,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        Text(
          filteredCourses[i].roomNum!,
          style: const TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        Text(
          '${filteredCourses[i].startTime!} - ${filteredCourses[i].endTime!}',
          style: const TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        if (i <
            filteredCourses.length - 1) // Add dotted line if not the last item
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            height: 1,
            width: double.infinity,
            color: Colors.black54,
          ),
      ]);
    }

    return widgets;
  }

  //used chatgpt for most of this function
  List<Widget> getEventWidgets(String weekday) {
    List<Widget> widgets = [];

    List<int> indexes = eventsList
        .asMap()
        .entries
        .where((entry) => entry.value.weekday == weekday)
        .map((entry) => entry.key)
        .toList();

    // Sort events by date and time
    indexes.sort((a, b) {
      if (eventsList[a].date!.compareTo(eventsList[b].date!) != 0) {
        return eventsList[a].date!.compareTo(eventsList[b].date!);
      } else {
        return DateTime.parse(
                "${DateFormat('h:mm a').parse(eventsList[a].time!.toUpperCase())}")
            .compareTo(DateTime.parse(
                "${DateFormat('h:mm a').parse(eventsList[b].time!.toUpperCase())}"));
      }
    });

    for (int i = 0; i < indexes.length; i++) {
      widgets.addAll([
        Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          confirmDismiss: (DismissDirection direction) async {
            return await _confirmDeleteEvent(eventsList[indexes[i]]);
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          onDismissed: (DismissDirection direction) {
            // This will not be executed immediately upon swipe due to confirmDismiss
            // If confirmed in the confirmation dialog, the item will be removed.
          },
          child: GestureDetector(
            onTap: () {
              _editEvent(eventsList[indexes[i]]);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  eventsList[indexes[i]].eventName!,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  eventsList[indexes[i]].location!,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "${eventsList[indexes[i]].date!.year}-${eventsList[indexes[i]].date!.month}-${eventsList[indexes[i]].date!.day} at ${eventsList[indexes[i]].time!}",
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                if (i < indexes.length - 1)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: 1,
                    width: double.infinity,
                    color: Colors.black54,
                  ),
              ],
            ),
          ),
        ),
      ]);
    }


    return widgets;
  }
}
