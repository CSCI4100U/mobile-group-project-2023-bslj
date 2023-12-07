import 'package:flutter/material.dart';
import 'package:campusmapper/models/sqflite/courses.dart'; // Import your Course model

class ScheduleProvider with ChangeNotifier {
  List<Course> _courses = [];

  List<Course> get courses => _courses;

  void addToSchedule(Course course) {
    _courses.add(course);
    notifyListeners();
  }

  void removeFromSchedule(Course course) {
    _courses.remove(course);
    notifyListeners();
  }
}
