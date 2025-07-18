import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class Moreoptionspostcontainer extends StatelessWidget {
  const Moreoptionspostcontainer({super.key, required this.ondelete});
  final Function() ondelete;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 15.h,
            ),
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
            SizedBox(
              height: 15.h,
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
            SizedBox(
              height: 15.h,
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
