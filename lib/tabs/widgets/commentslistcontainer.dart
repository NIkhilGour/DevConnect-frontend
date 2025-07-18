import 'package:cached_network_image/cached_network_image.dart';
import 'package:devconnect/core/jwtservice.dart';
import 'package:devconnect/core/user_id_service.dart';
import 'package:devconnect/tabs/apiServices/commentapi.dart';
import 'package:devconnect/tabs/model/comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Commentslistcontainer extends ConsumerStatefulWidget {
  const Commentslistcontainer(
      {super.key, required this.comments, required this.postId});
  final Comment comments;
  final int postId;

  @override
  ConsumerState<Commentslistcontainer> createState() =>
      _CommentslistcontainerState();
}

class _CommentslistcontainerState extends ConsumerState<Commentslistcontainer> {
  int? userid;

  @override
  void initState() {
    loaduser();
    super.initState();
  }

  void loaduser() async {
    final user = await SharedPreferencesService.getInt('userId');

    setState(() {
      userid = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: CachedNetworkImage(
                  height: 40.h,
                  width: 40.h,
                  fit: BoxFit.cover,
                  imageUrl: widget.comments.userProfile!.profilePictureUrl!),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              child: SizedBox(
                width: 270.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.comments.userProfile!.name!,
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      widget.comments.userProfile!.bio!,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      widget.comments.content!,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16.sp),
                    )
                  ],
                ),
              ),
            ),
            PopupMenuButton<String>(
              color: const Color.fromARGB(197, 0, 0, 0),
              onSelected: (value) {
                if (value == 'delete') {
                  ref
                      .watch(commentsProvider(widget.postId).notifier)
                      .deletecomment(widget.comments.id!);
                }
              },
              itemBuilder: (context) => [
                if (widget.comments.userProfile!.user!.id == userid)
                  PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                          )
                        ],
                      )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
