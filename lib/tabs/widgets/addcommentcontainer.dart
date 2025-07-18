import 'package:cached_network_image/cached_network_image.dart';
import 'package:devconnect/core/colors.dart';
import 'package:devconnect/tabs/apiServices/commentapi.dart';
import 'package:devconnect/tabs/apiServices/userdetails.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddCommentContainer extends ConsumerStatefulWidget {
  const AddCommentContainer({super.key, required this.postId});
  final int postId;
  @override
  ConsumerState<AddCommentContainer> createState() =>
      _AddCommentContainerState();
}

class _AddCommentContainerState extends ConsumerState<AddCommentContainer> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userdetailsprovider);
    return SizedBox(
      height: 60.h,
      child: Padding(
        padding: EdgeInsets.only(top: 7.h, bottom: 7.h, left: 16.w, right: 8.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: CachedNetworkImage(
                  height: 40.h,
                  width: 40.w,
                  fit: BoxFit.cover,
                  imageUrl: user.value!.profilePictureUrl!),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              child: Container(
                width: 200.w,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15.r)),
                child: TextField(
                  controller: controller,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    hintText: "Add a comment...",
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Container(
                height: 50.h,
                width: 90.w,
                decoration: BoxDecoration(
                    color: Color(0xFF876FE8).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r)),
                child: GestureDetector(
                  onTap: () {
                    ref
                        .read(commentsProvider(widget.postId).notifier)
                        .addcomment(
                            widget.postId, controller.text, user.value!);

                    controller.clear();
                  },
                  child: Center(
                    child: Text(
                      'Comment',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: seedcolor),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
