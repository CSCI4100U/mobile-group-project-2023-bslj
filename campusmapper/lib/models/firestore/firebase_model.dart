/*
Author: Luca Lotito
Firebase access class, handles reading from the firebase database and translating the data to the mapper (and in the future, other classes)
*/
import 'package:campusmapper/utilities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campusmapper/utilities/map_marker.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class FirebaseModel {
  //Returns the requested marker type
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<MapMarker>> getMarkersofType(List<String> type) async {
    List<MapMarker> results = [];
    for (int i = 0; i < type.length; i++) {
      //Firebase database is stared as a collection in a collection. Made it less messier if the document was the University, instead of the individual marker
      await _firestore
          .collection("MapMarker")
          .doc('OntarioTech')
          .collection(type[i])
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          results.add(MapMarker(
              id: docSnapshot.id,
              type: type[i],
              location: LatLng(docSnapshot["location"].latitude,
                  docSnapshot["location"].longitude),
              icon: Icon(
                  IconData(docSnapshot["icon"], fontFamily: 'MaterialIcons')),
              additionalInfo: docSnapshot["addInfo"]));
        }
      });
    }
    return results;
  }

  //Curently unused. Was originally intended to get all the marker types (As marker types are stored as individual collections within the OntarioTech document),
  //but decided it was easier to keep them as part of the app constants class
  Future<List<String>> getAllCategoryTypes() async {
    List<String> categories = [];
    await _firestore.collection("MapMarker").get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        categories.add(docSnapshot.id);
      }
    });
    return categories;
  }

  Future<User> login(String email, String password) async {
    User user = User(
        id: 'None',
        email: 'None',
        firstname: 'None',
        lastname: 'None',
        sid: 'None');
    await _firestore.collection("users").get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        if (docSnapshot['Email'] == email &&
            docSnapshot["Password"] == password) {
          user = User(
              id: docSnapshot.id,
              email: docSnapshot["Email"],
              firstname: docSnapshot["FirstName"],
              lastname: docSnapshot["LastName"],
              sid: docSnapshot["StudentID"]);
          return user;
        }
      }
    });
    return user;
  }

  Future<String> register(String email, String password, String firstname,
      String lastname, String sid) async {
    String id = "None";
    final data = {
      "Email": email,
      "FirstName": firstname,
      "LastName": lastname,
      "Password": password,
      "StudentID": sid
    };
    await _firestore
        .collection("users")
        .add(data)
        .then((docSnapshot) => id = docSnapshot.id);
    return id;
  }
}
