import 'package:devconnect/core/colors.dart';
import 'package:devconnect/core/user_id_service.dart';

import 'package:devconnect/tabs/apiServices/allpostApi.dart';

import 'package:devconnect/tabs/widgets/postcontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Homescreen extends ConsumerStatefulWidget {
  const Homescreen({super.key, required this.ontap});
  final Function() ontap;
  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  int? userId;

  void _loadUserId() async {
    final userid =
        await SharedPreferencesService.getInt('userId'); // Cache this
    setState(() {
      userId = userid;
    });
  }

  @override
  void initState() {
    _loadUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allpost = ref.watch(projectsNotifierProvider);
    return allpost.when(error: (error, stackTrace) {
      return Text(error.toString());
    }, loading: () {
      return Center(
        child: CircularProgressIndicator(
          color: seedcolor,
        ),
      );
    }, data: (post) {
      return Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Container(
            color: Colors.white,
            height: 70.h,
            width: double.infinity,
            padding: EdgeInsets.all(10.r),
            child: GestureDetector(
              onTap: widget.ontap,
              child: Container(
                height: 40.h,
                decoration: BoxDecoration(
                  color: backgroundcolor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.edit_square,
                          color: seedcolor,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Start a post',
                          style: TextStyle(fontSize: 20.sp),
                        )
                      ],
                    ),
                    Icon(
                      Icons.language_outlined,
                      color: seedcolor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          (post.isEmpty)
              ? Center(
                  child: Text('No Project Available'),
                )
              : Expanded(
                  child: ListView.builder(
                  itemCount: post.length,
                  itemBuilder: (context, index) {
                    return Postcontainer(
                      onConnect: () {},
                      onComment: () {},
                      onLike: () {
                        ref
                            .watch(projectsNotifierProvider.notifier)
                            .toggleLikePostInNotifier(post[index].id!);
                      },
                      isliking: ref.watch(likeLoadingProvider(post[index].id!)),
                      isLiked: post[index]
                              .likes
                              ?.any((like) => like.user?.id == userId) ??
                          false,
                      post: post[index],
                    );
                  },
                ))
        ],
      );
    });
  }
}
