import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:message_app/screens/authentic/login_screen.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:message_app/utils.dart';
import 'package:message_app/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _passController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _confirmPassController =
        TextEditingController();
    bool _loading = false;
    // FirebaseApp secondaryApp = Firebase.app('SecondaryApp');
    // FirebaseFirestore firestore =
    //     FirebaseFirestore.instanceFor(app: secondaryApp);

    FirebaseFirestore db = FirebaseFirestore.instance;

    handleSubmit() async {
      final email = _emailController.text;
      final password = _passController.text;
      final name = _nameController.text;

      try {
        DocumentReference doc = await db.collection("users").add({
          'email': email,
          'name': name,
        });

        print('DocumentSnapshot added with ID: ${doc.id}');
      } catch (e) {
        print('aaaaaa${e}');
      }

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      setState(() {
        _loading = true;
      });
      print('loading->>${_loading}');
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await credential.user?.updateDisplayName(name);
        print('credential->>>${credential}');

        Utils.showSnack(context, 'account Registered succssesfully! ');
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ));
        });
        // Add a new document with a generated id.

// Add a new document with a generated ID
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Utils.showSnack(context, 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          Utils.showSnack(
              context, 'The account already exists for that email.');
        } else {
          print(e.message);
        }
      } catch (e) {
        print(e);
      }
      setState(() {
        _loading = false;
      });
    }

    void _validate() {
      final _isValidate = _formKey.currentState?.validate();

      if (_isValidate!) {
        handleSubmit();
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 35, 37, 43),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create an Account',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'please fill the input blow here',
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              TextFormField(
                  controller: _nameController,
                  style: TextStyle(
                    color: Colors.white,
                    decorationColor: Colors.blueGrey,
                  ),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.blueGrey,
                      ),
                      hintText: 'Enter Your Full Name',
                      labelText: 'Full Name',
                      labelStyle: TextStyle(color: Colors.blueGrey),
                      hintStyle: TextStyle(color: Colors.blueGrey),
                      enabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.blueGrey,
                          ),
                          gapPadding: 5),
                      focusColor: Colors.blueGrey,
                      filled: true),
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Required'),
                  ])),
              SizedBox(
                height: 24,
              ),
              TextFormField(
                  controller: _emailController,
                  style: TextStyle(
                    color: Colors.white,
                    decorationColor: Colors.blueGrey,
                  ),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.blueGrey,
                      ),
                      hintText: 'Enter Your email',
                      labelText: 'EMAIL',
                      labelStyle: TextStyle(color: Colors.blueGrey),
                      hintStyle: TextStyle(color: Colors.blueGrey),
                      enabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.blueGrey,
                          ),
                          gapPadding: 5),
                      focusColor: Colors.blueGrey,
                      filled: true),
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Required'),
                    EmailValidator(errorText: 'Not Valid')
                  ])),
              SizedBox(
                height: 24,
              ),
              TextFormField(
                obscureText: true,
                controller: _passController,
                style: TextStyle(
                  color: Colors.white,
                  decorationColor: Colors.blueGrey,
                ),
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.blueGrey,
                    ),
                    hintText: 'Enter Your Password',
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.blueGrey),
                    hintStyle: TextStyle(color: Colors.blueGrey),
                    enabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.blueGrey,
                        ),
                        gapPadding: 5),
                    focusColor: Colors.blueGrey,
                    filled: true),
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Required'),
                  MinLengthValidator(6, errorText: 'at least 6 characters')
                ]),
              ),
              SizedBox(
                height: 24,
              ),
              TextFormField(
                  obscureText: true,
                  controller: _confirmPassController,
                  style: TextStyle(
                    color: Colors.white,
                    decorationColor: Colors.blueGrey,
                  ),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock_open,
                        color: Colors.blueGrey,
                      ),
                      hintText: 'ReEnterPassword',
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(color: Colors.blueGrey),
                      hintStyle: TextStyle(color: Colors.blueGrey),
                      enabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.blueGrey,
                          ),
                          gapPadding: 5),
                      focusColor: Colors.blueGrey,
                      filled: true),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'required';
                    }
                    if (value != _passController.text) {
                      return 'please confirm password';
                    }
                  }),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: EdgeInsets.only(top: 25, left: 40, right: 40),
                child: ElevatedButton(
                  onPressed: _validate,
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 20),
                    child: _loading
                        ? const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          )
                        : Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 30),
                          ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 96.6),
                child: Row(
                  children: [
                    Image.asset('assets/login/pngwing-3.png',
                        height: 20, width: 20),
                    TextButton(
                        onPressed: () {}, child: Text('SignUp With Google  ')),
                  ],
                ),
              ),
              SizedBox(
                height: 45,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
