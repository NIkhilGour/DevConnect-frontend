import 'package:cached_network_image/cached_network_image.dart';
import 'package:devconnect/core/colors.dart';
import 'package:devconnect/core/user_id_service.dart';
import 'package:devconnect/tabs/apiServices/allpostApi.dart';

import 'package:devconnect/tabs/model/post.dart';
import 'package:devconnect/tabs/screens/profilescren.dart';

import 'package:devconnect/tabs/widgets/commentscontainer.dart';

import 'package:devconnect/tabs/widgets/exapandabletext.dart';
import 'package:devconnect/tabs/widgets/moreoptionspostcontainer.dart';
import 'package:devconnect/tabs/widgets/skillsandgithubcontainer.dart';
import 'package:devconnect/tabs/widgets/videocontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Postcontainer extends ConsumerStatefulWidget {
  const Postcontainer(
      {super.key,
      required this.post,
      required this.onConnect,
      required this.onLike,
      required this.onComment,
      required this.isliking,
      required this.isLiked});
  final Post post;
  final Function() onConnect;
  final Function() onLike;
  final Function() onComment;
  final bool isliking;
  final bool isLiked;
  @override
  ConsumerState<Postcontainer> createState() => _PostcontainerState();
}

class _PostcontainerState extends ConsumerState<Postcontainer> {
  int? currentUserId;
  bool isProcessing = false;
  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final id = await SharedPreferencesService.getInt('userId');
    setState(() {
      currentUserId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ProfileScreen(
                                  userid: widget.post.userProfile!.user!.id!);
                            },
                          ));
                        },
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(15), // Not fully circular
                          child: CachedNetworkImage(
                            imageUrl:
                                widget.post.userProfile!.profilePictureUrl!,
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Text(
                        widget.post.userProfile!.name!,
                        style: GoogleFonts.poppins(
                            fontSize: 18.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SkillsAndGithubContainer(
                                skills: widget.post.techSkills!,
                                github: widget.post.github!,
                              );
                            },
                          );
                        },
                        icon: Image.asset(
                          'assets/icons/solution.png',
                          height: 27.h,
                          width: 27.w,
                          color: Colors.orange,
                        ))
                  ],
                ),
                if (widget.post.userProfile!.user!.id != currentUserId)
                  Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Container(
                        height: 40.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                            color: Color(0xFF876FE8).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r)),
                        child: GestureDetector(
                          onTap: widget.onConnect,
                          child: Center(
                            child: widget.post.isconnected == null
                                ? Text(
                                    'Connect',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: seedcolor),
                                  )
                                : widget.post.isconnected == 'APPROVED'
                                    ? null
                                    : Icon(
                                        Icons.pending_outlined,
                                        color: seedcolor,
                                        size: 25.r,
                                      ),
                          ),
                        ),
                      )),
                SizedBox(
                  width: 5.w,
                ),
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Moreoptionspostcontainer(
                            post: widget.post,
                            userId: currentUserId!,
                            ondelete: () {
                              ref
                                  .watch(projectsNotifierProvider.notifier)
                                  .deletepostnotifier(widget.post.id!);
                            },
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.more_vert_outlined))
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.r),
              child: ExpandableText(
                text: widget.post.description!,
                style: GoogleFonts.lato(fontWeight: FontWeight.w600),
              ),
            ),
            if (widget.post.fileUrl != null)
              Padding(
                padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                child: widget.post.fileType!.contains('image')
                    ? Center(
                        child: CachedNetworkImage(
                          imageUrl: widget.post.fileUrl!,
                          height: 300.h,
                          fit: BoxFit.contain,
                        ),
                      )
                    : Videocontainer(url: widget.post.fileUrl!),
              ),
            SizedBox(
              height: 5.h,
            ),
            Container(
              height: 1.h,
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 16.w, right: 16.w, top: 8.h, bottom: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: widget.isliking ? null : widget.onLike,
                    child: Column(
                      children: [
                        Icon(
                          widget.isLiked
                              ? Icons.thumb_up
                              : Icons.thumb_up_off_alt_outlined,
                          size: 20.r,
                          color: widget.isLiked ? seedcolor : Colors.black,
                          fill: widget.isLiked ? 1 : 0,
                        ),
                        Row(
                          children: [
                            Text(
                              'Like',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            widget.post.likecout! > 0
                                ? Text(widget.post.likecout.toString())
                                : SizedBox()
                          ],
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: DraggableScrollableSheet(
                                initialChildSize: 0.50,
                                minChildSize: 0.5,
                                maxChildSize: 0.95,
                                expand: false,
                                builder: (context, scrollController) {
                                  return Commentscontainer(
                                      postId: widget.post.id!,
                                      scrollController: scrollController);
                                },
                              ));
                        },
                      );
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          size: 20.r,
                        ),
                        Text(
                          'Comment',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
