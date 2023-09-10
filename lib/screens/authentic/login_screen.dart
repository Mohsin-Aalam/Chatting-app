import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:message_app/models/user_model.dart';
import 'package:message_app/screens/authentic/sign_up.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:message_app/screens/tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;

  signInWithGoogle() async {
    late UserDetail user;
    GoogleSignIn _googleSignIn = GoogleSignIn();
    var result = await _googleSignIn.signIn();
    final userData = await result?.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: userData?.accessToken, idToken: userData?.idToken);
    var finalResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    //print("result->${result}");
    // print("displayName->${result?.displayName}");
    // print('email->${result?.email}');
    // print('photo->${result?.photoUrl}');

    var querySnapshot = await db
        .collection("users")
        .where("email", isEqualTo: result?.email)
        .get();

    if (querySnapshot.docs.length == 0) {
      DocumentReference doc = await db.collection("users").add({
        'email': result?.email,
        'name': result?.displayName,
        "photoUrl": result?.photoUrl,
      });
      print('document Id ${doc.id}');

      user = UserDetail(
        id: doc.id,
        email: result!.email,
        name: result.displayName!,
        photoUrl: result.photoUrl,
        pushToken: '',
      );
    } else {
      //if data present in firebase database
      print('sanpShot=>${querySnapshot.docs[0].data()}');
      user = UserDetail.fromFirestore(querySnapshot.docs[0]);
    }

    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    _prefs.setString('userEmail', user.email);
    _prefs.setString('userName', user.name);
    _prefs.setString('id', user.id);
    _prefs.setString('photoUrl', user.photoUrl!);
    _prefs.setString('about', '');
    print('user=>>${user}');

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const TabScreen(),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // displayScreen();
  }

  void displayScreen() async {
    var querySnapshot = await db
        .collection("users")
        .where("email", isEqualTo: "zoro@gmail.com")
        .get();
    //  print(querySnapshot.docs);
    // for (final snapshot in querySnapshot.docs) {
    //   print('${snapshot.id} ${snapshot.data()}');
    // }

    //  .then(
    //     (querySnapshot) {
    //       print("Successfully completed");

    //     },
    //     onError: (e) => print("Error completing: $e"),
    //   );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(6, 8, 10, 67),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(50),
                child: Image.asset(
                  'assets/login/pngwing.png',
                ),
              ),
              Text(
                'Login',
                style: TextStyle(
                    fontSize: 45,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'please sign in to continue',
                style: TextStyle(color: Color.fromARGB(255, 103, 100, 100)),
              ),
              SizedBox(height: 14),
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
                    EmailValidator(errorText: 'please enter valid Email')
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
              Padding(
                padding: EdgeInsets.only(top: 25, left: 40, right: 40),
                child: ElevatedButton(
                  onPressed: () async {
                    _formKey.currentState!.validate();

                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passController.text);

                      print("signInCredential-->>${credential}");

                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => TabScreen(),
                      ));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        Utils.showSnack(context, 'not user found');
                      } else if (e.code == 'wrong-password') {
                        Utils.showSnack(
                            context, 'wrong password provided for the user');
                      }
                    }
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 20),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : Text(
                            'login',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: TextButton(
                    onPressed: () {}, child: Text('Forgot Password?')),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 83),
                child: Row(
                  children: [
                    Image.asset('assets/login/pngwing-3.png',
                        height: 20, width: 20),
                    TextButton(
                        onPressed: () {
                          signInWithGoogle();
                        },
                        child: Text('SignUp With Google  ')),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ));
                    },
                    child: Text(
                      'Sign Up',
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
