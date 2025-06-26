import 'dart:async';

import 'package:devconnect/auth/apiServices/signupApi.dart';
import 'package:devconnect/auth/userdetails.dart';
import 'package:devconnect/auth/widgets/textfield_widget.dart';
import 'package:devconnect/core/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Signup extends StatefulWidget {
  const Signup({super.key, required this.onClick});
  final void Function() onClick;

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailcontroller = TextEditingController();

  final TextEditingController passwordcontroller = TextEditingController();

  String errormsg = '';

  bool isauthenticating = false;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void signup(String email, String password) async {
    setState(() {
      isauthenticating = true;
    });
    final response = await signupApi(email, password);

    if (response == null) {
      setState(() {
        isauthenticating = false;
        errormsg = 'Failed to create account';
      });
    } else {
      setState(() {
        isauthenticating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account Create Please login to continue')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.h,
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 204, 198, 230),
            Colors.white,
            Colors.white
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 25.h),
            Container(
              height: 50.h,
              width: 50.w,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Icon(CupertinoIcons.globe, size: 40.r, color: seedcolor),
            ),
            Text('Welcome',
                style: GoogleFonts.redHatText(
                    fontSize: 25.sp, fontWeight: FontWeight.w600)),
            Text(
              'Please enter your details to create',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 10.h),
            TextfieldWidget(
              title: 'Email address',
              subtitle: 'Enter your email',
              controller: emailcontroller,
              validator: validateEmail,
            ),
            TextfieldWidget(
              title: 'Password',
              subtitle: 'Enter password',
              controller: passwordcontroller,
              obscureText: true,
              validator: validatePassword,
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.all(8.0.r),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(seedcolor)),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    signup(emailcontroller.text, passwordcontroller.text);
                  }
                },
                child: Center(
                  child: isauthenticating
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Sign up',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account? '),
                GestureDetector(
                  onTap: widget.onClick,
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: seedcolor),
                  ),
                )
              ],
            ),
            if (errormsg != '')
              Text(
                errormsg,
                style: TextStyle(color: Colors.red),
              )
          ],
        ),
      ),
    );
  }
}
