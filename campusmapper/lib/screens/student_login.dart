//Author: Luca Lotito
//Page that allows the user to login/register for the service. Interacts with firebase and sqflite
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:campusmapper/models/firestore/firebase_model.dart';
import 'package:campusmapper/models/sqflite/logged_in_model.dart';
import 'package:campusmapper/utilities/classes/user.dart';

class StudentLoginPage extends StatefulWidget {
  const StudentLoginPage({super.key, required this.forced});
  //Forced is if the call comes from a feature that requires user login.
  ////Needed due to issues found while exiting the method, recursive calls
  final bool forced;
  @override
  StudentLoginPageState createState() => StudentLoginPageState();
}

class StudentLoginPageState extends State<StudentLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //Controls what menu the user interacts with
  bool loggingIn = true;
  final _formKey = GlobalKey<FormState>();
  final FirebaseModel _fireDatabase = FirebaseModel();
  final UserModel _sqlDatabase = UserModel();
  String email = '';
  String firstName = '';
  String lastName = '';
  String password = '';
  String id = '';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Return to homepage
          returnToMain(context);

          // Return 'false' to prevent recursive menu calls
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white38,
              title: Row(children: [
                const Icon(Icons.school),
                Padding(
                    padding: const EdgeInsetsDirectional.only(start: 10),
                    child: (loggingIn)
                        ? const Text("Student Login")
                        : const Text("Register an Account"))
              ]),
            ),
            body: (loggingIn) ? login() : register()));
  }

  Widget login() {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email cannot be null';
                      } else if (!EmailValidator.validate(value)) {
                        return 'Invalid Email address';
                      } else {
                        email = value;
                      }
                      return null;
                    },
                  )),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be null';
                  } else {
                    password = value;
                  }
                  return null;
                },
              ),
              Row(children: [
                const Text('Don\'t have an account?'),
                TextButton(
                    onPressed: () {
                      setState(() {
                        loggingIn = false;
                      });
                    },
                    child: const Text('Sign Up'))
              ]),
              const Padding(padding: EdgeInsets.only(top: 30.0)),
              SizedBox(
                width: 175,
                height: 30,
                child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _attemptLogin(email, password);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white38,
                        shape: const StadiumBorder()),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    )),
              ),
            ],
          ),
        ));
  }

  Widget register() {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email cannot be null';
                      } else if (!EmailValidator.validate(value)) {
                        return 'Invalid Email address';
                      } else {
                        email = value;
                      }
                      return null;
                    },
                  )),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be null';
                  } else {
                    password = value;
                  }
                  return null;
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 50)),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'First name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'First name cannot be null';
                  } else {
                    firstName = value;
                  }
                  return null;
                },
              ),
              Container(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Last name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Last name cannot be null';
                      } else {
                        lastName = value;
                      }
                      return null;
                    },
                  )),
              Row(children: [
                const Text('Have an account?'),
                TextButton(
                    onPressed: () {
                      setState(() {
                        loggingIn = true;
                      });
                    },
                    child: const Text('Log In'))
              ]),
              const Padding(padding: EdgeInsets.only(top: 30.0)),
              SizedBox(
                width: 175,
                height: 30,
                child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _attemptRegistration(
                            email, password, firstName, lastName, id);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white38,
                        shape: const StadiumBorder()),
                    child: const Text(
                      "Register",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    )),
              ),
            ],
          ),
        ));
  }

  //Tries to log the user in
  Future _attemptLogin(String email, String password) async {
    User user = await _fireDatabase.login(email, password);
    //If the user id doesn't exist with email and password, not a user
    if (user.id == "None") {
      var warningSnackbar = const SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.white38,
        content: Text(
          "Username or Password is Incorrect!",
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(warningSnackbar);
      setState(() {
        _emailController.clear();
        _passwordController.clear();
      });
      //If user id exists with email and password, exists
    } else {
      _sqlDatabase.insertUser(user);
      var successSnackbar = SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.white38,
        content: Text(
          "Successfully logged in. Welcome ${user.firstname}",
          style: const TextStyle(fontSize: 16),
        ),
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
      returnToMain(context);
    }
  }

  //Attempts to create a new user account
  Future _attemptRegistration(String email, String password, String firstname,
      String lastname, String sid) async {
    User user = await _fireDatabase.login(email, password);
    //Unlike login, no user id means an account can be created
    if (user.id == "None") {
      id = await _fireDatabase.register(
          email, password, firstname, lastname, sid);
      //Creates the user
      _sqlDatabase.insertUser(
          User(id: id, email: email, firstname: firstname, lastname: lastname));
      var successSnackbar = SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.white38,
        content: Text(
          "Successfully registered. Welcome $firstname",
          style: const TextStyle(fontSize: 16),
        ),
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
      returnToMain(context);
      //If user already exists
    } else {
      var warningSnackbar = const SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.white38,
        content: Text(
          "User is already registered!",
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(warningSnackbar);
      setState(() {
        _emailController.clear();
        _passwordController.clear();
      });
    }
  }

  //Becuase the login page can be called from the widget on the appbar or forced, unique ways to exit are needed
  //Could probably be neater, but with how the project was built, I don't know where to refactor to make the code neater
  void returnToMain(BuildContext context) {
    FocusScope.of(context).unfocus();
    Future.delayed(const Duration(milliseconds: 750), () {
      //If coming from the widget, poping till home screen is fine
      if (!context.mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
      //If coming from a forced dialog, need to specify the route
      if (widget.forced) {
        Navigator.pushNamed(context, '/');
      }
    });
  }
}
