import 'package:cached_network_image/cached_network_image.dart';

import 'package:devconnect/tabs/apiServices/userdetails.dart';
import 'package:devconnect/tabs/screens/profile_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Drawerscreen extends ConsumerStatefulWidget {
  const Drawerscreen({super.key});

  @override
  ConsumerState<Drawerscreen> createState() => _DrawerscreenState();
}

class _DrawerscreenState extends ConsumerState<Drawerscreen> {
  @override
  Widget build(BuildContext context) {
    final userprofiledata = ref.watch(userdetailsprovider);

    return userprofiledata.when(
      data: (userprofile) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ProfileScreen();
                    },
                  ));
                },
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.r),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            imageUrl: userprofile.profilePictureUrl!,
                            height: 90.h,
                            width: 90.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.r),
                        child: Text(
                          userprofile.name!,
                          style: GoogleFonts.poppins(
                              fontSize: 22.sp, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.r),
                        child: Text(
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          userprofile.bio!,
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.r),
                        child: Text(
                          userprofile.location!,
                          style: GoogleFonts.lato(
                            color: const Color.fromARGB(255, 66, 64, 64),
                            fontSize: 17.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Container(
                height: 0.7.h,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16.r, left: 16.r, top: 16.r),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      size: 30.r,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      'Logout',
                      style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Text(error.toString()),
        );
      },
      loading: () {
        return SizedBox();
      },
    );
  }
}
