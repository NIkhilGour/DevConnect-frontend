import 'package:devconnect/auth/apiServices/loginApi.dart';
import 'package:devconnect/auth/userdetails.dart';
import 'package:devconnect/auth/widgets/textfield_widget.dart';
import 'package:devconnect/core/colors.dart';
import 'package:devconnect/core/jwtservice.dart';
import 'package:devconnect/core/user_id_service.dart';
import 'package:devconnect/tabs/tabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.onClick});
  final void Function() onClick;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String errormsg = '';
  bool isauthenticating = false;

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isauthenticating = true;
      });
      final response =
          await login(emailcontroller.text, passwordcontroller.text);

      if (response == null) {
        setState(() {
          isauthenticating = false;
          errormsg = 'Login Failed';
        });
      } else {
        if (response['isnewuser'] == true) {
          setState(() {
            isauthenticating = false;
          });
          if (mounted) {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return Userdetails(
                  token: response['jwt'],
                );
              },
            ));
          }
        } else {
          setState(() {
            isauthenticating = false;
          });
          await SharedPreferencesService.setInt('userId', response['id']);
          await JWTService.addtoken(response['jwt']);

          if (mounted) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) {
                return Tabs();
              },
            ), (route) => false);
          }
        }
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
        color: Colors.white,
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 204, 198, 230),
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
              child: Icon(
                CupertinoIcons.globe,
                size: 40.r,
                color: seedcolor,
              ),
            ),
            Text(
              'Welcome back',
              style: GoogleFonts.redHatText(
                  fontSize: 25.sp, fontWeight: FontWeight.w600),
            ),
            Text(
              'Please enter your details to sign in',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 10.h),
            TextfieldWidget(
              title: 'Email address',
              subtitle: 'Enter your email',
              controller: emailcontroller,
              validator: _emailValidator,
            ),
            TextfieldWidget(
              title: 'Password',
              subtitle: 'Enter password',
              controller: passwordcontroller,
              validator: _passwordValidator,
              obscureText: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {}, child: const Text('Forgot password?')),
            ),
            Padding(
              padding: EdgeInsets.all(8.0.r),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(seedcolor)),
                onPressed: _submit,
                child: Center(
                  child: isauthenticating
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Sign in',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account? '),
                GestureDetector(
                  onTap: widget.onClick,
                  child: Text(
                    'Create an account',
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
