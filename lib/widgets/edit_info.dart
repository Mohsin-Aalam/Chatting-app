import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class EditWidget extends StatelessWidget {
  EditWidget({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.check),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Form(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 12),
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
                  )),
              SizedBox(
                height: 24,
              ),
              TextFormField(
                  controller: _userController,
                  style: TextStyle(
                    decorationColor: Colors.blueGrey,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.blueGrey,
                    ),
                    hintText: 'Enter Your Full Name',
                    labelText: 'User Name',
                    labelStyle: TextStyle(color: Colors.blueGrey),
                    hintStyle: TextStyle(color: Colors.blueGrey),
                  )),
              SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: _emailController,
                style: TextStyle(
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
                ),
              ),
              SizedBox(
                height: 24,
              ),
              TextFormField(
                  controller: _bioController,
                  style: TextStyle(
                    decorationColor: Colors.blueGrey,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.blueGrey,
                    ),
                    labelText: 'Bio',
                    labelStyle: TextStyle(color: Colors.blueGrey),
                    hintStyle: TextStyle(color: Colors.blueGrey),
                  )),
            ]),
      ),
    );
  }
}
