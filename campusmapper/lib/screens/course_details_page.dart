/*
Author: Brock Davidge - 100787894
Displays detailed information about a specific course, including the course name, professor,
room, day, and time. Additional details can be added as needed.
*/

import 'package:flutter/material.dart';
import 'package:campusmapper/utilities/classes/courses.dart'; // Import your Course model
import 'package:provider/provider.dart';
import 'package:campusmapper/utilities/schedule_provider.dart';

class CourseDetailsPage extends StatelessWidget {
  final Course course;

  const CourseDetailsPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Course Details',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color.fromRGBO(255, 255, 224, 1.0),
        ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, false);
            return false;
          },
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.lightBlueAccent],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    course.courseName ?? 'Unknown Course',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Professor: ${course.profName ?? 'Unknown Professor'}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Room: ${course.roomNum ?? 'Unknown Room'}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Time: ${course.startTime ?? 'Unknown'} - ${course.endTime ?? 'Unknown'}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  // ... other details
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Remove the course from the schedule
                      ScheduleProvider scheduleProvider =
                          Provider.of<ScheduleProvider>(context, listen: false);
                      scheduleProvider.removeFromSchedule(course);

                      // Navigate back to the previous screen
                      Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(
                          255, 255, 224, 1.0), // Banana yellow color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 8.0,
                      padding: const EdgeInsets.all(0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Remove from Schedule',
                            style: TextStyle(
                              color: Colors.black, // Set text color to black
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
