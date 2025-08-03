import 'package:devconnect/core/user_id_service.dart';
import 'package:devconnect/tabs/apiServices/groupnotifier.dart';
import 'package:devconnect/tabs/screens/chatscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Groupscreen extends ConsumerStatefulWidget {
  const Groupscreen({super.key});

  @override
  ConsumerState<Groupscreen> createState() => _GroupscreenState();
}

class _GroupscreenState extends ConsumerState<Groupscreen> {
  int? userId;
  @override
  void initState() {
    _loadUserId();
    super.initState();
  }

  void _loadUserId() async {
    final userid =
        await SharedPreferencesService.getInt('userId'); // Cache this
    setState(() {
      userId = userid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupsdata = ref.watch(groupProvider);
    return groupsdata.when(
      data: (data) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final group = data[index];

            return Card(
              elevation: 2,
              margin: EdgeInsets.only(bottom: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                leading: CircleAvatar(
                  radius: 24.r,
                  backgroundColor: Colors.blueGrey.shade400,
                  child: Icon(Icons.group_outlined,
                      color: Colors.white, size: 28.r),
                ),
                title: Text(
                  group.name ?? 'Unnamed Group',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16.r),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Chatscreen(
                          isforjoin: false, userId: userId, group: group);
                    },
                  ));
                },
              ),
            );
          },
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Text('Something went Wrong'),
        );
      },
      loading: () {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
