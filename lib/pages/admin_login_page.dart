import 'package:flutter/material.dart';

import 'home_page.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() =>
      _AdminLoginPageState();
}

class _AdminLoginPageState
    extends State<AdminLoginPage> {

  final emailCtrl =
      TextEditingController();

  final passCtrl =
      TextEditingController();

  Future<void> login() async {

    if (emailCtrl.text.trim() ==
            "jagadales3586@gmail.com" &&
        passCtrl.text.trim() ==
            "123456") {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const HomePage(),
        ),
      );

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "ईमेल किंवा पासवर्ड चुकीचा आहे",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Admin Login",
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: emailCtrl,
              decoration:
                  const InputDecoration(
                labelText: "Email",
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration:
                  const InputDecoration(
                labelText: "Password",
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: login,
              child: const Text(
                "Login",
              ),
            ),
          ],
        ),
      ),
    );
  }
}