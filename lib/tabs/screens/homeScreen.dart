import 'package:devconnect/core/colors.dart';
import 'package:devconnect/core/user_id_service.dart';

import 'package:devconnect/tabs/apiServices/allpostApi.dart';
import 'package:devconnect/tabs/apiServices/publishpost.dart';

import 'package:devconnect/tabs/widgets/postcontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Homescreen extends ConsumerStatefulWidget {
  const Homescreen({super.key, required this.ontap, required this.publishData});
  final Function() ontap;
  final Map<String, dynamic>? publishData;
  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  int? userId;
  bool _isPublishing = false;
  bool _isCompleted = false;
  void _loadUserId() async {
    final userid =
        await SharedPreferencesService.getInt('userId'); // Cache this
    setState(() {
      userId = userid;
    });
  }

  void _startPublishing(Map data) async {
    setState(() {
      _isPublishing = true;
      _isCompleted = false;
    });

    try {
      await publishPostApi(
        data['description'],
        data['github'],
        data['skills'],
        data['file'],
      );

      setState(() {
        _isPublishing = false;
        _isCompleted = true;
      });

      // Hide success tile after 2 seconds
      await Future.delayed(Duration(seconds: 2));
      if (mounted) {
        setState(() {
          _isCompleted = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to publish: $e')));
      }

      setState(() {
        _isPublishing = false;
        _isCompleted = false;
      });
    }
  }

  @override
  void initState() {
    _loadUserId();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Homescreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.publishData != null && !_isPublishing && !_isCompleted) {
      _startPublishing(widget.publishData!);
    }
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
          if (_isPublishing || _isCompleted)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _isCompleted
                        ? Icon(Icons.check_circle,
                            color: Colors.green, size: 28)
                        : SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.5, color: seedcolor),
                          ),
                    SizedBox(width: 12.w),
                    Text(
                      _isCompleted ? 'Post published!' : 'Finishing up...',
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
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
                      onConnect: () {
                        ref
                            .watch(projectsNotifierProvider.notifier)
                            .toggleConnectionStatus(post[index].id!);
                      },
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
