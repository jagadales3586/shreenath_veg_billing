import 'package:flutter/material.dart';

import 'customer_order_page.dart';

class CustomerLoginPage extends StatefulWidget {
  const CustomerLoginPage({super.key});

  @override
  State<CustomerLoginPage> createState() =>
      _CustomerLoginPageState();
}

class _CustomerLoginPageState
    extends State<CustomerLoginPage> {

    final nameCtrl =
    TextEditingController();  

  final mobileCtrl =
      TextEditingController();

  final otpCtrl =
      TextEditingController();

  bool otpSent = false;

  void sendOtp() {

    if (mobileCtrl.text.length != 10) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "योग्य मोबाईल नंबर टाका",
          ),
        ),
      );

      return;
    }

    setState(() {
      otpSent = true;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "OTP पाठवला",
        ),
      ),
    );
  }

  void verifyOtp() {

    if (otpCtrl.text == "1234") {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
        builder: (_) => CustomerOrderPage(
        customerName: nameCtrl.text,
        mobile: mobileCtrl.text,
         ),
        ),
      );

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "OTP चुकीचा आहे",
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
          "ग्राहक लॉगिन",
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(20),

        child: Column(
         children: [

TextField(
  controller: nameCtrl,
  decoration: const InputDecoration(
    labelText: "ग्राहकाचे नाव",
  ),
),

TextField(
  controller: mobileCtrl,
  keyboardType: TextInputType.phone,
  decoration: const InputDecoration(
    labelText: "मोबाईल नंबर",
  ),
),


  const SizedBox(height: 20),

  ElevatedButton(
    onPressed: sendOtp,
    child: const Text("OTP पाठवा"),
    ),
    
            if (otpSent) ...[

              const SizedBox(height: 20),

              TextField(
                controller: otpCtrl,
                keyboardType:
                    TextInputType.number,
                decoration:
                    const InputDecoration(
                  labelText: "OTP",
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: verifyOtp,
                child: const Text(
                  "OTP Verify",
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}