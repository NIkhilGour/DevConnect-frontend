import 'package:devconnect/tabs/model/post.dart';
import 'package:devconnect/tabs/screens/chatscreen.dart';
import 'package:devconnect/tabs/widgets/creategroupdialog.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class Moreoptionspostcontainer extends StatelessWidget {
  const Moreoptionspostcontainer({
    super.key,
    required this.ondelete,
    required this.post,
    required this.userId,
  });
  final Function() ondelete;
  final Post post;
  final int userId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 15.h,
          mainAxisSize: MainAxisSize.min,
          children: [
            (post.isconnected == 'APPROVED' ||
                    userId == post.userProfile!.user!.id!)
                ? post.group != null
                    ? (post.group!.members!.contains(userId))
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return Chatscreen(
                                      userId: userId,
                                      isforjoin: false,
                                      group: post.group!);
                                },
                              ));
                            },
                            child: Row(children: [
                              Icon(
                                Icons.people,
                                size: 30.r,
                              ),
                              SizedBox(
                                width: 12.w,
                              ),
                              Text(
                                'Open chat',
                                style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ]),
                          )
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return Chatscreen(
                                    isforjoin: true,
                                    group: post.group!,
                                    userId: userId,
                                  );
                                },
                              ));
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.people,
                                  size: 30.r,
                                ),
                                SizedBox(
                                  width: 12.w,
                                ),
                                Text(
                                  'Join Group',
                                  style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          )
                    : GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CreateGroupDialog(
                                post: post,
                              );
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.people,
                              size: 30.r,
                            ),
                            SizedBox(
                              width: 12.w,
                            ),
                            Text(
                              'Create Group',
                              style: TextStyle(
                                  fontSize: 17.sp, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                : Row(children: [
                    Icon(
                      Icons.connect_without_contact_rounded,
                      size: 30.r,
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    Text(
                      'Connect to post',
                      style: TextStyle(
                          fontSize: 17.sp, fontWeight: FontWeight.w500),
                    ),
                  ]),
            Row(
              children: [
                Icon(
                  Icons.archive_outlined,
                  size: 30.r,
                ),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  'Save',
                  style:
                      TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.share,
                  size: 30.r,
                ),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  'Share',
                  style:
                      TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                ondelete();
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    size: 30.r,
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Text(
                    'Delete',
                    style:
                        TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
