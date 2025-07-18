import 'package:cached_network_image/cached_network_image.dart';
import 'package:devconnect/core/colors.dart';
import 'package:devconnect/tabs/apiServices/commentApi.dart';
import 'package:devconnect/tabs/widgets/addcommentcontainer.dart';
import 'package:devconnect/tabs/widgets/commentslistcontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Commentscontainer extends ConsumerStatefulWidget {
  const Commentscontainer(
      {super.key, required this.postId, required this.scrollController});
  final int postId;
  final ScrollController scrollController;
  @override
  ConsumerState<Commentscontainer> createState() => _CommentscontainerState();
}

class _CommentscontainerState extends ConsumerState<Commentscontainer> {
  @override
  Widget build(BuildContext context) {
    final commentsData = ref.watch(commentsProvider(widget.postId));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 10.h),
          Text('Comments', style: GoogleFonts.roboto(fontSize: 18.sp)),
          SizedBox(height: 10.h),
          Expanded(
            child: commentsData.when(
              data: (comments) {
                print("🟢 UI got comments: ${comments.map((c) => c.id)}");
                if (comments.isEmpty) {
                  return const Center(child: Text('No Comments Available'));
                }
                return ListView.builder(
                  key: ValueKey(comments.map((c) => c.id).join(',')),
                  itemCount: comments.length,
                  controller: widget.scrollController,
                  itemBuilder: (context, index) => Commentslistcontainer(
                      key: ValueKey(comments[index].id),
                      postId: widget.postId,
                      comments: comments[index]),
                );
              },
              error: (_, __) =>
                  const Center(child: Text('Error loading comments')),
              loading: () => Center(
                child: CircularProgressIndicator(color: seedcolor),
              ),
            ),
          ),
          AddCommentContainer(postId: widget.postId),
        ],
      ),
    );
  }
}
