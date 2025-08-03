import 'dart:io';

import 'package:devconnect/auth/apiServices/getskills.dart';
import 'package:devconnect/auth/apiServices/userdetailsApi.dart';
import 'package:devconnect/auth/model/skill.dart';
import 'package:devconnect/auth/widgets/skillsselection.dart';
import 'package:devconnect/auth/widgets/textfield_widget.dart';
import 'package:devconnect/core/colors.dart';
import 'package:devconnect/core/jwtservice.dart';
import 'package:devconnect/core/user_id_service.dart';
import 'package:devconnect/tabs/tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class Userdetails extends StatefulWidget {
  const Userdetails({super.key, required this.token});
  final String token;

  @override
  State<Userdetails> createState() => _UserdetailsState();
}

class _UserdetailsState extends State<Userdetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController usernamecontroller = TextEditingController();
  final TextEditingController phonenumbercontroller = TextEditingController();
  final TextEditingController biocontroller = TextEditingController();
  final TextEditingController locationcontroller = TextEditingController();

  String? dropdownvalue;

  List<Skill> selectedSkills = [];
  List<Skill> allSkills = [];
  DateTime? dob;
  File? image;

  @override
  void initState() {
    fetchSkills(widget.token);
    super.initState();
  }

  void fetchSkills(String token) async {
    final List<Skill>? result = await getAllSkills(token);
    if (result == null) return;
    setState(() {
      allSkills = result;
    });
  }

  void pickimage() async {
    XFile? pickedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedimage != null) {
      setState(() {
        image = File(pickedimage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30.h),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        height: 100.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[400],
                        ),
                        child: image != null
                            ? ClipOval(
                                child: Image.file(image!, fit: BoxFit.cover))
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 18.r,
                          child: IconButton(
                            icon: Icon(Icons.edit,
                                size: 18.r, color: Colors.black),
                            onPressed: pickimage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                TextfieldWidget(
                  title: 'Username',
                  subtitle: 'Enter your name',
                  controller: usernamecontroller,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Username cannot be empty';
                    }
                    return null;
                  },
                ),
                TextfieldWidget(
                  title: 'Bio',
                  subtitle: 'Tell about yourself',
                  controller: biocontroller,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Bio cannot be empty';
                    }
                    return null;
                  },
                ),
                TextfieldWidget(
                  title: 'Phone',
                  subtitle: 'Enter your phone number',
                  controller: phonenumbercontroller,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone number cannot be empty';
                    }
                    return null;
                  },
                ),
                TextfieldWidget(
                  title: 'Location',
                  subtitle: 'Enter your location',
                  controller: locationcontroller,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Location cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        DateTime? pickeddate = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1930),
                          lastDate: DateTime.now(),
                        );
                        if (pickeddate != null) {
                          setState(() {
                            dob = pickeddate;
                          });
                        }
                      },
                      icon: Icon(Icons.calendar_month),
                      label: Text(
                        'Date of birth',
                        style: TextStyle(color: seedcolor),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 12.h),
                      ),
                    ),
                    Container(
                      height: 40.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: dob != null
                            ? Text(
                                dob.toString().substring(0, 10),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text(
                                'Select DOB',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Gender",
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 170.w,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        value: dropdownvalue,
                        hint: Text("Select your gender"),
                        items: ['Male', 'Female', 'Prefer not to say']
                            .map((gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            dropdownvalue = value;
                          });
                        },
                        icon: Icon(Icons.keyboard_arrow_down_rounded),
                        dropdownColor: Colors.white,
                        style: TextStyle(color: Colors.black, fontSize: 14.sp),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select gender';
                          }
                          return null;
                        },
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.w, vertical: 12.h),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Skillsselection(
                              onselect: (p0) {
                                setState(() {
                                  selectedSkills = p0;
                                });
                              },
                              allSkills: allSkills,
                              selectedSkills: selectedSkills,
                            );
                          },
                        );
                      },
                      child: Text(
                        'Select skills',
                        style: TextStyle(fontSize: 16.sp, color: seedcolor),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                  ),
                  onPressed: () async {
                    if (image == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Please select profile picture")),
                      );
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      if (dob == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Please select date of birth")),
                        );
                        return;
                      }
                      if (selectedSkills.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Please select at least one skill")),
                        );
                        return;
                      }

                      final response = await setUserDetails(userProfile: {
                        "name": usernamecontroller.text,
                        "phonenumber": phonenumbercontroller.text,
                        "gender": dropdownvalue,
                        "location": locationcontroller.text,
                        "dateofbirth": dob!.toString().substring(0, 10),
                        "bio": biocontroller.text,
                        "techSkills": selectedSkills
                      }, token: widget.token, profilePictureFile: image);

                      if (response != null) {
                        await SharedPreferencesService.setInt(
                            'userId', response['user']['id']);
                        JWTService.addtoken(widget.token);

                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Tabs()),
                            (Route<dynamic> route) => false,
                          );
                        }
                      }

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Something went wrong")),
                        );

                        return;
                      }
                    }
                  },
                  child: Text(
                    'Save Details',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
