import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:p8/screens/yourAllset.dart';
import 'package:p8/widgets/customscaff.dart';
import 'package:p8/widgets/image_picker.dart';

final _firebase = FirebaseAuth.instance;

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<AuthenticationScreen> {
  var _isLog = true;
  var _enteredEmail = '';
  var _enteredPass = '';
  var _enteredUsername = '';
  var _isAuthenticating = false;
  File? _selectedImage;
  bool rememberMe = true;

  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid || (!_isLog && _selectedImage == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and pick an image!')),
      );
      return;
    }

    _formKey.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });

      if (_isLog) {
        await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPass,
        );
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPass,
        );

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'image_url': imageUrl,
        });
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Authentication failed')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred!')),
      );
    } finally {
      setState(() {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => Yourallset(),
          ),
        );
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 25, right: 25, bottom: 10, top: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  width: 5,
                  color: Color.fromARGB(255, 8, 0, 0),
                ),
                left: BorderSide(
                  width: 4,
                  color: Color.fromARGB(255, 8, 0, 0),
                ),
                right: BorderSide(
                  width: 2,
                  color: Color.fromARGB(255, 8, 0, 0),
                ),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(135),
              ),
            ),
            child: Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment(-1.2, 0.5),
                          child: Text(
                            textAlign: TextAlign.start,
                            _isLog ? 'WELCOME BACK !' : '',
                            style: TextStyle(
                                color: Color.fromRGBO(24, 43, 78, 0.301),
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        if (!_isLog)
                          ImagePickerWidget(
                            onPickImage: (pickedImage) {
                              _selectedImage = pickedImage;
                            },
                          ),
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Email ',
                              labelStyle: TextStyle(fontSize: 14)),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                        ),
                        if (!_isLog)
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Username',
                                labelStyle: TextStyle(fontSize: 14)),
                            enableSuggestions: false,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length < 4) {
                                return 'Please enter a valid username (at least 4 characters).';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredUsername = value!;
                            },
                          ),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(fontSize: 14)),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'Password must be at least 6 characters long.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPass = value!;
                          },
                        ),
                        const SizedBox(height: 15),
                        const SizedBox(height: 30),
                        if (_isAuthenticating)
                          const CircularProgressIndicator(),
                        if (!_isAuthenticating)
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(400, 10),
                                backgroundColor: Color.fromRGBO(29, 54, 96, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                )),
                            child: Text(
                              _isLog ? 'Login' : 'Sign Up',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        const SizedBox(height: 40),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Divider(
                                        thickness: 0.7, color: Colors.grey)),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    _isLog ? 'Login with' : 'Sign Up with',
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 10.5),
                                  ),
                                ),
                                Expanded(
                                    child: Divider(
                                        thickness: 0.7, color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(height: 15),

                            // Social Media Login
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.facebook_rounded,
                                  color:
                                      const Color.fromARGB(170, 22, 102, 168),
                                ),
                                const SizedBox(width: 60),
                                Icon(
                                  Icons.email_outlined,
                                  color: const Color.fromARGB(158, 119, 4, 4),
                                ),
                                const SizedBox(width: 60),
                                Icon(
                                  Icons.apple,
                                  color:
                                      const Color.fromARGB(194, 158, 158, 158),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Dont have an account ?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w200,
                                      color: const Color.fromARGB(
                                          199, 96, 125, 139)),
                                ),
                                if (!_isAuthenticating)
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _isLog = !_isLog;
                                      });
                                    },
                                    child: Text(
                                      _isLog ? 'Sign up' : 'Login',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
